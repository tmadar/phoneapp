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
  
  def patch_agent
    if params[:agent_call_id]
      @call = Call.find(params[:agent_call_id])
    else
      @call = Call.received_from_agent(params)
    end
    
    @customer_call = Call.find(params[:call_id])
    
    if params[:next_agent] and params[:agent_call_id]
      @call.user.unlock_agent
      @customer_call.patch_agent
    end
    
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def unlock_agent
    @user = User.where(params[:agent_id]).first
    @user.unlock_agent
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @zendesk = ZendeskTicket.find(@call.zendesk_id)
    if params[:Digits] and params[:Digits].size > 0
      @zendesk.solve!
    end
    
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def conference_queue
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @call.patch_agent
    
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
    @call.change_disposition! if params[:Digits] == "1"
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
end
