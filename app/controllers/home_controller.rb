class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @calls = Call.all
    Call.update_incomplete
    respond_to do |format|
      format.html
    end
  end
  
end
