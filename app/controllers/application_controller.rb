class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :hack_for_layout
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format| 
      format.html { redirect_to root_url, :alert => exception.message }
      format.js { flash[:alert] = exception.message; render "layouts/error", :status => 403 }
    end
  end
  
  def hack_for_layout
    @empty = params[:empty]
    params.delete(:empty) # hack for improper HTML (probably an unclosed div)
  end
  
end
