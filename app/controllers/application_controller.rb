class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format| 
      format.html { redirect_to root_url, :alert => exception.message }
      format.js { flash[:alert] = exception.message; render "layouts/error", :status => 403 }
    end
  end
  
end
