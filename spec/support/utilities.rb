#returns full title on a per page basis
	def full_title(page)
		base_title = "pomos - pomodoro timer"
		if page.empty?
			base_title
		else
			"#{base_title} | #{page}"
		end
	end