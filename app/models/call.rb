module ZendeskCallMethods
  
  #links the call to its corresponding zendesk ticket for an agent to 
  #go view
  def zendesk_call_string(zendesk_id)
    if zendesk_id != nil
      url = "https://tmadar.zendesk.com/tickets/#{zendesk_id}"
    end
    return url
  end
  
  def zendesk_ticket_url
    return zendesk_call_string(zendesk_id)
  end
  
  #When a call is made by a customer, a new ticket will be added into
  #zendesk with default values
  def add_ticket
    new_zendesk = ZendeskTicket.new
    new_zendesk.subject = "Call from #{self.caller}"
    new_zendesk.status = "open"
    new_zendesk.priority = "high"
    new_zendesk.type = "problem"
    new_zendesk.description = "A call was made to us by #{self.caller} at #{self.received_at}."
    new_zendesk.save
    return new_zendesk.id
  end
  
  #Able to access the zendesk API through the Call object
  def zendesk_ticket
    ZendeskTicket.find(self.zendesk_id) if self.zendesk_id
  end
  
  #If an agent decides that at the end of the call that the
  #customer's issue has been solved, they may press a key
  # to "close" the call and change the status to "solved"
  def update_zendesk_ticket
    Thread.new do
      if self.needs_update
        ticket = zendesk_ticket
        ticket.group_id = 20310643
        ticket.assignee_id = 245140892
        ticket.status = DISPOSITION_MAPPINGS[self.disposition]
        ticket.save
        self.needs_update = nil
      end
    end
  end
  
end

class Call < ActiveRecord::Base
  include ZendeskCallMethods
  include HomeHelper
  
  DISPOSITIONS = ["Open", "Closed"]
  DISPOSITION_MAPPINGS = { "Open" => "open", "Closed" => "solved" }

  attr_accessible :caller, :received_at, :duration, :twilio_call_sid,
                  :zendesk_id, :rescheduled_to, :status, :comment, :recording,
                  :disposition, :last_comment, :user_id, :rescheduled_to_nice
  
  attr_accessor :needs_update
  
  has_many :comments, :autosave => true, :dependent => :destroy
  belongs_to :user
  
  before_save :toggle_update
  after_save :update_zendesk_ticket
  
  #A Call object will be created and given params from Twilio.
  #If a customer calls, a zendesk ticket will be created.

  def self.received(params)
    if params and params[:Caller]
      new_call = self.new
      new_call.caller = params[:From].sub("+","")
      new_call.received_at = Time.now
      new_call.twilio_call_sid = params[:CallSid]
      new_call.status =  params[:CallStatus]
      if (user = User.where(["phone = ?", new_call.caller]).first)
        new_call.user = user
        if new_call.user.availability == "Yes"
          new_call.disposition = "Online"
        else
          new_call.disposition = "Offline"
        end
      else
        zendesk_id = new_call.add_ticket
        new_call.zendesk_id = zendesk_id
      end
      new_call.save
      return new_call
    end
  end
  
  #Creates a new Call object so that the agent can be patched in w/ the
  #calling customer
  def self.received_from_agent(params)
    if params and params[:Caller]
      new_call = self.new
      new_call.caller = params[:To].sub("+","")
      puts new_call.caller
      new_call.received_at = Time.now
      new_call.twilio_call_sid = params[:CallSid]
      new_call.status =  params[:CallStatus]
      if (user = User.where(["phone = ?", new_call.caller]).first)
        new_call.user = user
      end
      customer_call = self.find(params[:call_id]) if params[:call_id]
      new_call.zendesk_id = customer_call.zendesk_id
      new_call.save
      return new_call
    end
  end
  
  #When a customer's call is completed, further twilio information
  #regarding the call will be stored to the Call object.
  def self.update_incomplete
    calls = self.where("status != ?", "completed")
    calls.each do |call|
      twilio_call = $twilio_client.account.calls.get(call.twilio_call_sid)
      call.received_at = twilio_call.start_time
      call.duration = twilio_call.duration
      call.status = twilio_call.status
      if twilio_call.recordings.list.first
        call.recording = twilio_call.recordings.list.first.wav
      end
      call.save
    end
  end

  #Toggle agent's status when they call into the system
  def change_disposition!
    if self.disposition == "Offline"
      self.disposition = "Online"
    else
      self.disposition = "Offline"
    end
    self.save
  end
  
  #Assigns a specific agent from User to a call
  def assign_agent(user_id)
    found = User.where(:id => user_id)
    if found.empty? == true
      found = "Assign"
      return found
    else
      return found[0]["name"]
    end
  end
  
  #Method to see all the calls that are in-progress or ringing
  #for the AJAX table to appear on the Home page
  def self.in_progress
    where(:status => ["in-progress", "ringing"], :user_id => nil)
  end
  
  #A queue of available agents will be made so that when a customer
  #calls, the 1st agent in the queue will be contacted.
  #If failed to be reached, the next agent in the queue will be
  #contacted, looping until the queue has been emptied or an agent
  #has been patched in.
  def patch_agent
    if not $redis.exists("call:#{self.id}:started_calling_agents")
      $redis.setex("call:#{self.id}:started_calling_agents", 600, "1")
      User.available.each do |user|
        $redis.rpush("call:#{self.id}:agents_to_call", user.id)
      end
      $redis.expire("call:#{self.id}:agents_to_call", 600)
    end   
    
    if $redis.exists("call:#{self.id}:started_calling_agents")
      id = $redis.lpop("call:#{self.id}:agents_to_call")
      if id       
        user = User.where(:id => id).first
        user.accept_call(self)
      else
        $twilio_client.account.calls.get(self.twilio_call_sid).redirect_to("http://184.183.31.238:3000/call_handler/leave_message.xml?sorry=true")
      end
    end
  end
  
  def agents_to_call
    User.where(:id => $redis.lrange("call:#{self.id}:agents_to_call", 0, $redis.llen("call:#{self.id}:agents_to_call")+1))
  end
  
  #If a recording for a call exists, a link will be generated
  #in the View Call Info section. Otherwise, "No Message" will appear.
  def recording?
    not self.recording.nil?
  end
  
  #Checks to see whether or not an agent has changed the call status
  #before deciding to "save" to AR
  def toggle_update
    if self.disposition_changed?
      self.needs_update = true
    end
  end
  
  #Method to find all the calls with a "Closed" disposition
  def self.solved
    where("disposition = ? ", "Closed")
  end
  
  def rescheduled_to_nice=(value)
    value = cleanup_time_string(value)
    
    begin
      write_attribute(:rescheduled_to, Time.parse(value))
    rescue
      errors.add(:rescheduled_to, "couldn't be understood")
    end
    
    puts self.errors.inspect
  end
  
  def rescheduled_to_nice
    send(:rescheduled_to)
  end
  
  # def received_at=(value)
  #   value = cleanup_time_string(value)
  #   super(Time.parse(value))
  # end
  # 
  # def received_at
  #   if super
  #     return nice_time(super.localtime)
  #   else
  #     return nil
  #   end
  # end
  
  def rescheduled_to=(value)
    value = cleanup_time_string(value.localtime)
    super(Time.parse(value))
  end
  
  def rescheduled_to
    if read_attribute(:rescheduled_to)
      return nice_time(super.localtime)
    else
      return nil
    end
  end
      
  def cleanup_time_string(value)
    value = value.downcase.gsub(/yesterday/, (Time.now - 1.day).localtime.to_date.strftime("%m/%d/%Y"))
    value = value.downcase.gsub(/today/, (Time.now).localtime.to_date.strftime("%m/%d/%Y"))
    value = value.downcase.gsub(/tomorrow/, (Time.now + 1.day).localtime.to_date.strftime("%m/%d/%Y"))
    
    begin
      day_string = value.match(/\D+/).to_s
      value = value.downcase.gsub(day_string, Date.parse(day_string).strftime("%m/%d/%Y") + " ")
    rescue ArgumentError => e
      errors.add(:rescheduled_to, "couldn't be understood")
    end

    return value
  end
  
  def received_at_original
    read_attribute(:received_at)
  end
  
  
end
