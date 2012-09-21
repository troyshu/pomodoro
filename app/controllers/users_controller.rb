class UsersController < ApplicationController
  include UsersHelper
  include ActionView::Helpers::TextHelper

  before_filter :signed_in_user, only: [:edit, :update]

  def show
	 if params[:id]==nil
    @user = current_user
   else
    @user = User.find(params[:id])	
   end

	 @pomodoros = @user.pomodoros.finished.paginate(page: params[:page], per_page: 10)
   if @pomodoros.finished.count >= 80 and @pomodoros.finished.count < FREE_MAX_POMODOROS and is_free_user(@user) and current_user == @user
    @pomodoros_left = FREE_MAX_POMODOROS - @pomodoros.finished.count
    @pomodoro_pluralize = pluralize(@pomodoros_left, 'Pomodoro')
    flash.now[:warning] = "<b>Warning!</b> You have #{@pomodoro_pluralize} left before old Pomodoros will start being deleted. <a href='/pricing '>Click here to upgrade.</a>".html_safe
   elsif @pomodoros.finished.count == 100 and is_free_user(@user) and current_user == @user
    flash.now[:error] = "<b>Warning!</b> You have hit the #{FREE_MAX_POMODOROS} Pomodoro limit for free users. After you complete a new Pomodoro, the oldest one in your history will be deleted. <a href='/pricing '>Click here to upgrade.</a>".html_safe

   end
  end

  def get_data
   #generate default data
   #@user = current_user #this gets the current signed in user. 
   @user = User.find(params[:id])   #get user as specifided by URL params

   #logger.debug("in get_data: #{params}")
   #logger.debug("number of pomodoros: #{@user.pomodoros.finished}")
   @data = morph_data(@user.pomodoros.finished, params[:type], params[:granularity], params[:timeframe], params[:tag_filter])
   #logger.debug("get_data data: #{@data}")


   render :text => @data
  end

  def new
    if signed_in?
      redirect_to root_path
    end

  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		#handle a successful save
  		sign_in @user

      #add user to general newsletter list
      Gibbon.new(MAIL_CHIMP_API_KEY).list_subscribe(:id => "0e829bc994", :email_address => params[:user][:email], :double_optin => false)
      #logger.debug("email #{params[:user][:email]} added to mailchimp")

  		flash[:success] = "Thanks for signing up!"
  		redirect_to @user
  	else 
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
    else
      render 'edit'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
    def morph_data(raw_pomodoros, type, granularity, timeframe, tag_filter)
      logger.debug("tag_filter: #{tag_filter}")
      
      #only get pomodoros relevant to current timeframe
      cutoff = 20.years.ago::time #the "default", though the default specified by JS is last month
      if timeframe=="last week"
        cutoff = 1.week.ago.beginning_of_day::time
      elsif timeframe=="last month"
        cutoff = 1.month.ago.beginning_of_day::time
      elsif timeframe=="last year"
        cutoff = 1.year.ago.beginning_of_day::time
      end 

      #get date range start and end date
      sorted_pomodoros = raw_pomodoros.sort_by {|p| p.updated_at}
      
      start_date = sorted_pomodoros.first.updated_at.to_date
      end_date = sorted_pomodoros.last.updated_at.to_date

      if not tag_filter.blank?
        #apply tag filter to raw pomodoros
        filtered_pomodoros = raw_pomodoros.tagged_with(tag_filter)
      else
        filtered_pomodoros = raw_pomodoros
      end


      @grouped_pomodoros = filtered_pomodoros
      

      
      #FILL in days with no pomodoros with 0

      #logger.debug("last: #{@grouped_pomodoros.last.updated_at}")
      #logger.debug("first: #{@grouped_pomodoros.first.updated_at}")

      daterange = ((start_date)..(end_date)).to_a.map{|x| x.to_s(:db)}
      logger.debug("daterange: #{daterange}")
      daterange.each do |date| 
        temp_pomodoro = Pomodoro.new(finished:true, created_at: date, updated_at: date)
        #add onto original list of pomodoros a list of pomodoros, one on each date, with length 0
        @grouped_pomodoros = @grouped_pomodoros.append(temp_pomodoro)
      end

      #check to see if pomodoro lies within the specified timeframe. if not, skip it
      #logger.debug("pomodoros size before: #{@grouped_pomodoros.count}")
      @grouped_pomodoros = @grouped_pomodoros.select{|p| p.updated_at >= cutoff }

      #then DON'T FORGET to subtract out 1 (if daily), 7 (if weekly), etc. at the end from pomodoro count
      
      #logger.debug("pomodoros size after: #{@grouped_pomodoros.count}")

      #group by granularity (sort first)
      @grouped_pomodoros = @grouped_pomodoros.sort_by { |p| p.updated_at }
      
      logger.debug("first pomodoro date: #{@grouped_pomodoros.first.updated_at}")
      logger.debug("last pomodoro date: #{@grouped_pomodoros.last.updated_at}")


      if granularity=="daily"
        @grouped_pomodoros = @grouped_pomodoros.group_by{|p| p.updated_at.at_beginning_of_day }
      elsif granularity=="weekly"
        @grouped_pomodoros = @grouped_pomodoros.group_by{|p| p.updated_at.at_beginning_of_week }
      end
        
      #count up pomodoros (either by total time, or count)
      grouped_array = Array.new

      #first, push headers
      #x labels
      if granularity=="daily"
        date_label = "Day"
      elsif granularity=="weekly"
        date_label = "Week"
      end

      #y labels
      if type=="total time"
        if not tag_filter.blank?
          type_label = "#{tag_filter}"
        else
          type_label = "total time (mintues)"
        end
      elsif type=="count"
        if not tag_filter.blank?
          type_label = "#{tag_filter}"
        else
          type_label = "number of Pomodoros: total"
        end
      end
        

          
      grouped_array.push([date_label, type_label])
      #logger.debug("successfulley grouped. moving onto summation.")
      @grouped_pomodoros.each do |group, pomodoros|
        sum = 0

        

        pomodoros.each do |pomodoro|

          #ignore zero length pomodoros
          if pomodoro.id==nil
            next
          end

          if type=="total time"
            sum = sum + pomodoro.length
          elsif type=="count"
            sum = sum + 1
          end

        end


        #reformat the group labels
        new_group = group
        if granularity=="daily"
          #logger.debug("DAILY GRANULARITY. changing labels")
          new_group = group.strftime("%A, %D")

        elsif granularity=="weekly"
          new_group = group.strftime("%A, %D")

        end
        
        #formatted_sum = format_sum(sum)

        grouped_array.push([new_group, sum])
      end
      
      return grouped_array

    end

    def format_sum(x)
      hours = (x/60.0).floor
      minutes = x%60

      return "#{hours}:#{minutes}"
    end
end
