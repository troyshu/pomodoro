class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		#logger.debug("current user: #{current_user}")
  		redirect_to current_user
  	end
  end

  def help
  end
end
