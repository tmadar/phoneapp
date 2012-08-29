class CallHandlersController < ApplicationController
  
  #The start of the twilio calling process. 
  #Takes in the twilio info in params.
  def show
    @call = Call.received(params)
    respond_to do |format|
      format.html
      format.xml
    end
  end

  #Updates in ActiveRecord the customer's phone number if they decide to 
  #change it in the menu options
  def update_number
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @call.update_attribute(:caller, params[:Digits]) if params[:Digits] and params[:Digits].size > 1     
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  #Will attempt to connect the agent to a customer. If the 1st isn't available,
  #it will attempt to call the next agent by priority
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
  
  #When a call by a customer has finished w/ an agent responding,
  #the agent becomes "unlocked" so that he may be contacted by
  #additional customers
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
  
  #The customer upon calling us will be entered into twilio's
  #conference queue. While waiting, an agent will be attempted to
  #be patched into the call
  def conference_queue
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @call.patch_agent
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  #If a customer cannot reach an agent or decides at the beginning of their call
  #to leave a message. Updates the call's attribute of finding the twilio url
  #of the recording for the agent to access later
  def leave_message
    @call = Call.where(:twilio_call_sid => params[:CallSid]).first
    @call.update_attribute(:recording, params[:RecordingUrl]) if params[:RecordingDuration] and params[:RecordingDuration].length > 1
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  #When an agent calls into the system they may toggle their availability
  #with the press of any digit on the keypad
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
