class CallHandlersController < ApplicationController
  
  def show
    @call = Call.received(params)
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def update_number
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @call.update_attribute(:caller, params[:Digits]) if params[:Digits] and params[:Digits].size > 1
        
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def conference_queue
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
            
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def leave_message
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @call.update_attribute(:recording, params[:RecordingUrl]) if params[:RecordingDuration] and params[:RecordingDuration].length > 1
    
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def agent_information
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @call.user.toggle_availability! if params[:Digits] == "1"
      
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
end
