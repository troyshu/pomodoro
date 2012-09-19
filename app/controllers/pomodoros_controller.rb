class PomodorosController < ApplicationController
	include SessionsHelper
  include UsersHelper

  before_filter :signed_in_user, only: [:create, :destroy, :update]


  def create

  	@user = current_user
  	
    #if the user is a free user, and has too many pomodoros
    if @user.pomodoros.finished.count >= FREE_MAX_POMODOROS and @user.user_level==STARTER_LEVEL
      #delete the first (oldest) pomodoro
      @user.pomodoros.finished.last.destroy
    end

  	@pomodoro = @user.pomodoros.create!(finished: false)
  	render :text => @pomodoro.id
  end


  def destroy
  end

  def update
    @user = current_user
    #logger.debug("updated called with pomodoro_id: #{params[:pomodoro_id]}")

  	@pomodoro = Pomodoro.find_by_id(params[:pomodoro_id])
  	@pomodoro.update_attributes(length: params[:length], finished: true)
  	
    #check to see how many tags current user has
    users_tag_count = @user.owned_tags.count
    if not params[:pomodoro_tags].empty?
      users_tag_count = users_tag_count + params[:pomodoro_tags].split(',').count
    end
    
    #if free user, and tags (including new ones) is greater than limit, DON'T TAG
    if is_free_user(@user) and users_tag_count > FREE_MAX_TAGS
      render :text => params
    else
      if not params[:pomodoro_tags].empty?
        @user.tag(@pomodoro, :with=>params[:pomodoro_tags], :on=>:tags)
      end

      render :text => params
    end
  end

  

end