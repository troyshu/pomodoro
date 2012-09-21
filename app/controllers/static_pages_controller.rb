class StaticPagesController < ApplicationController
  include UsersHelper

  def home
  	if signed_in?
  		logger.debug("current user: #{current_user}")
  		redirect_to current_user
  	end
  end

  def help
  end

  def getpremium

	
	if request.post?

		#obviously, only upgrade if user_level is currently 1
		if current_user.user_level == STARTER_LEVEL
			#logger.debug("in getpremium")

			# set your secret key: remember to change this to your live secret key in production
			# see your keys here https://manage.stripe.com/account
			Stripe.api_key = "sk_xzUVMy9CL5PtgS0QseInV6rclgyJL"

			# get the credit card details submitted by the form
			token = params[:stripeToken]

			# create a Customer
			customer = Stripe::Customer.create(
			  :card => token,
			  :plan => "premium",
			  :email => current_user.email
			)
			
			#update current user's user level
			current_user.update_attribute(:user_level, PREMIUM_LEVEL)
			#logger.debug("current user's new user level: #{current_user.user_level}")

			#redirect to home, with a flash
			flash[:success] = "Your account has been upgraded to Premium! Thank you for supporting POMOS! Please sign in again."
			redirect_to root_path
		end
	elsif request.get?
		if current_user.user_level == PREMIUM_LEVEL
			redirect_to current_user
		end
	end

  end
end
