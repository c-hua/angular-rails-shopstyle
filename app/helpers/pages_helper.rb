module PagesHelper

	def percent_off(original, sale)
		((original-sale)/original) *100
	end
end
