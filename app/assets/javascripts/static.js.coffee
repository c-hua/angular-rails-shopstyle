var yogurtApp = angular.module('yogurt-app', ['ngResource']).config(
    ['$httpProvider', function($httpProvider) {
    var authToken = angular.element("meta[name=\"csrf-token\"]").attr("content");
    var defaults = $httpProvider.defaults.headers;

    defaults.common["X-CSRF-TOKEN"] = authToken;
    defaults.patch = defaults.patch || {};
    defaults.patch['Content-Type'] = 'application/json';
    defaults.common['Accept'] = 'application/json';
}]);

yogurtApp.factory('Yogurt', ['$resource', function($resource) {
  return $resource('/yogurts/:id',
     {id: '@id'},
     {update: { method: 'PATCH'}});
}]);

yogurtApp.controller('YogurtCtrl', ['$scope', 'Yogurt', function($scope, Yogurt) {
    $scope.yogurts= [];

    $scope.newYogurt = new Yogurt();

    Yogurt.query(function(yogurts) {
      $scope.yogurts = yogurts;
   });

    $scope.saveYogurt = function () {
      $scope.newYogurt.$save(function(yogurt) {
        $scope.yogurts.push(yogurt)
        $scope.newYogurt = new Yogurt();
      });
    }

    $scope.deleteYogurt = function (yogurt) {
      yogurt.$delete(function() {
        position = $scope.yogurts.indexOf(yogurt);
        $scope.yogurts.splice(position, 1);
      }, function(errors) {
        $scope.errors = errors.data
      });
    }

    $scope.showYogurt = function(yogurt) {
      yogurt.details = true;
      yogurt.editing = false;
    }

    $scope.hideYogurt = function(yogurt) {
      yogurt.details = false;
    }

    $scope.editYogurt = function(yogurt) {
      yogurt.editing = true;
      yogurt.details = false;
    }

    $scope.updateYogurt = function(yogurt) {
      yogurt.$update(function() {
        yogurt.editing = false;
      }, function(errors) {
        $scope.errors = errors.data
      });
    }

    $scope.clearErrors = function() {
      $scope.errors = null;
    }
}])