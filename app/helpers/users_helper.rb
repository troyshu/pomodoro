module UsersHelper
	include ActsAsTaggableOn::TagsHelper
	
	#GLOBAL VARIABLES
	MAIL_CHIMP_API_KEY = "f5fa2cbf650d0992f31fd1b7d15861c0-us5"

	#free user max pomodoros
	FREE_MAX_POMODOROS = 100
	FREE_MAX_TAGS = 5
	

	STARTER_LEVEL = 1
	PREMIUM_LEVEL = 2

	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url, alt:user.name, class: "gravatar")
	end


	def is_free_user(user)
		if user.user_level==STARTER_LEVEL
			return true
		else
			return false
		end
	end
	
end
