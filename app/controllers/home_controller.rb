class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @calls = Call.where(:user_id => nil).paginate page: params[:page], order: 'created_at desc', per_page: 10
    @user_activities = Call.where("user_id is not null")
    
    #Call.update_incomplete
    respond_to do |format|
      format.html
    end
  end
  
end
