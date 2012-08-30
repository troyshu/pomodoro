module SessionsHelper
	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def current_user=(user) #need to define the current_user assignment. since self isn't accessible outside this helper...
		@current_user = user
	end

	def current_user
		# we don't want just @current_user. local vars only stored for current page, so it will dissappear as soon as we navigate somewhere else
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def signed_in_user
	    unless signed_in?
	      store_location
	      redirect_to signin_url, notice: "Please sign in."
	    end
	  end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end


	#friendly forwarding
	def redirect_back_or(default)
	    redirect_to(session[:return_to] || default)
	    session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url.sub("pomodoros/create", "")
	end
	

	

end
