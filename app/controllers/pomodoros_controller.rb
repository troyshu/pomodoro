class PomodorosController < ApplicationController
	include SessionsHelper

  before_filter :signed_in_user, only: [:create, :destroy, :update]


  def create
  	@user = current_user
  	
  	@pomodoro = @user.pomodoros.create!(finished: false)
  	render :text => @pomodoro.id
  end


  def destroy
  end

  def update
    //logger.debug("updated called with pomodoro_id: #{params[:pomodoro_id]}")

  	@pomodoro = Pomodoro.find_by_id(params[:pomodoro_id])
  	@pomodoro.update_attributes(length: params[:length], finished: true)
  	render :text => params
  end

end