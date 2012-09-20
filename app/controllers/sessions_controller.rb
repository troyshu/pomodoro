class SessionsController < ApplicationController
	def new
		if signed_in?
	      redirect_to root_path
	    end
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user
			if user.authenticate(params[:session][:password] )
				#sign in the user and redirect to user's show page
				sign_in user
				redirect_back_or user
			else
				flash.now[:error] = "Invalid user/password combination."
				render 'new'
			end
		else
			#create an error message and redirect to sign-in page
			flash.now[:error] = "Invalid user/password combination."
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
