class Call < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :caller, :received_at, :duration, :twilio_call_sid,
                  :zendesk_id, :reschedule_time, :status, :comment, :audio_message
  has_many :comments
  
  def self.received(params)
    if params and params[:Called]
      new_call = self.new
      new_call.caller = params[:From]
      new_call.received_at = Time.now
      new_call.twilio_call_sid = params[:CallSid]
      new_call.status =  params[:CallStatus]
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
      call.save
    end
  end
  
  def self.hangup_all
    update_incomplete
    calls = self.where("status != ?", "completed")
    calls.each do |call|
      twilio_call = $twilio_client.account.calls.get(call.twilio_call_sid)
      twilio_call.hangup
    end
    update_incomplete
  end  
end
