class Call < ActiveRecord::Base
  
  DISPOSITIONS = ["Open", "Closed"]
  DISPOSITION_MAPPINGS = { "Open" => "open", "Closed" => "solved" }
  
  # attr_accessible :title, :body
  attr_accessible :caller, :received_at, :duration, :twilio_call_sid,
                  :zendesk_id, :rescheduled_to, :status, :comment, :recording,
                  :disposition, :last_comment, :user_id
  
  attr_accessor :needs_update
  
  has_many :comments, :autosave => true, :dependent => :destroy
  belongs_to :user
  
  before_save :toggle_update
  after_save :update_zendesk_ticket
  
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

  def change_disposition!
    if self.disposition == "Offline"
      self.disposition = "Online"
    else
      self.disposition = "Offline"
    end
    self.save
  end
  
  def zendesk_call_string(zendesk_id)
    if zendesk_id != nil
      url = "https://tmadar.zendesk.com/tickets/#{zendesk_id}"
    end
    return url
  end
  
  def assign_agent(user_id)
    found = User.where(:id => user_id)
    if found.empty? == true
      found = "Assign"
      return found
    else
      return found[0]["name"]
    end
  end
  
  def self.in_progress
    where(:status => ["in-progress", "ringing"], :user_id => nil)
  end
  
  # def special
  #   if not $redis.exists("call:#{self.id}:started_calling_agents")
  #     $redis.setex("call:#{self.id}:started_calling_agents", 600, "1")
  #     User.available.each do |user|
  #       $redis.rpush("call:#{self.id}:agents_to_call", user.id)
  #     end
  #     $redis.expire("call:#{self.id}:agents_to_call", 600)
  #   end
  # end
  # 
  # def special2
  #   if $redis.exists("call:#{self.id}:started_calling_agents")
  #     id = $redis.lpop("call:#{self.id}:agents_to_call")
  #     if id       
  #       user = User.where(:id => id).first
  #       puts "Calling #{user.name}"
  #     else
  #       puts "Leaving message"
  #     end
  #   end
  # end
  
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
  
  def check_recording(call)
    if call.recording != nil
      return call.recording
    else
      return "No Message"
    end
  end
  
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
  
  def zendesk_ticket
    ZendeskTicket.find(self.zendesk_id) if self.zendesk_id
  end
  
  def toggle_update
    if self.disposition_changed?
      self.needs_update = true
    end
  end
  
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
  
  def self.solved
    where("disposition = ? ", "Closed")
  end
  
end
