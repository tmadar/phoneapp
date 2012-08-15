class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @calls = Call.where(:disposition => "Open", :status => "completed", :user_id => nil).paginate page: params[:page], order: 'created_at desc', per_page: 5
    @user_activities = Call.where("user_id is not null")
    @in_progress_calls = Call.in_progress
    @users = User.all

    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
