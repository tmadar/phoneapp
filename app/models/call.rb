class Call < ActiveRecord::Base
  
  DISPOSITIONS = ["Open", "Closed"]
  
  # attr_accessible :title, :body
  attr_accessible :caller, :received_at, :duration, :twilio_call_sid,
                  :zendesk_id, :reschedule_time, :status, :comment, :recording,
                  :disposition, :last_comment
                  
  has_many :comments, :autosave => true, :dependent => :destroy
  belongs_to :user
  
  def self.received(params)
    if params and params[:Called]
      new_call = self.new
      new_call.caller = params[:From]
      new_call.received_at = Time.now
      new_call.twilio_call_sid = params[:CallSid]
      new_call.status =  params[:CallStatus]
      
      if (user = User.where(["phone = ?", new_call.caller]).first)
        new_call.user = user
        
        if new_call.user.availability == "Yes"
          new_call.disposition = "Offline"
        else
          new_call.disposition = "Online"
        end
        
        new_call.user.toggle_availability!
      end
      
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
    
end
