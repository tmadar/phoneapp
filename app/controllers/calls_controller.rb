class CallsController < ApplicationController
  
  def index
    @calls = Call.all
    respond_to do |format|
      format.html
      format.xml { render 'index.xml.builder' }
    end
  end
  
  def conference_michael
    respond_to do |format|
      format.xml { render 'conference_michael.xml.builder' }
    end
  end
  
end
