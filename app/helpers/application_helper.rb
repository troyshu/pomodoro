module ApplicationHelper

	#GLOBAL VARIABLES
	#free user max pomodoros
	FREE_MAX_POMODOROS = 100

	STARTER_LEVEL = 1

	#returns full title on a per page basis
	def full_title(page)
		base_title = "POMOS"
		if page.empty?
			base_title
		else
			"#{base_title} | #{page}"
		end
	end


end
