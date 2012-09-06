class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  #The agent will be shown all of the calls which are "Open
  #Also, the most recent 5 actions of an agent calling in is shown
  def index
    @calls = Call.where(:disposition => "Open", :status => "completed", :user_id => nil).paginate page: params[:page], order: 'created_at desc', per_page: 5
    @user_activities = Call.where("user_id is not null").limit(5).order("received_at desc").joins(:user)
    @in_progress_calls = Call.in_progress
    @users = User.all
    respond_to do |format|
      format.html { render :layout => "#{@empty ? "empty" : "application"}"}
      format.js
    end
  end
  
end
