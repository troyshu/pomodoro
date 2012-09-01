module ApplicationHelper
	#returns full title on a per page basis
	def full_title(page)
		base_title = "Pomos"
		if page.empty?
			base_title
		else
			"#{base_title} | #{page}"
		end
	end
end
