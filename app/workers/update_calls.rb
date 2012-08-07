class UpdateCalls
  @queue = :call_status_queue
  
  def self.perform(call_id=nil)
    if not call_id
      redis = Resque.redis
      calls = Call.where("status != ?", "completed")
      queued_calls = Resque.peek "#{@queue.to_s}", 0, Resque.size("#{@queue.to_s}")
      queued_calls = [queued_calls] if not queued_calls.is_a?(Array)

      calls.each do |call|
        # Don't enqueue smaller task if already included in queue set
        if not queued_calls.detect { |v| v["class"] == self.name && v["args"] && v["args"].size > 0 && v["args"][0] == call.id }
          Resque.enqueue UpdateCalls, call.id
        end
      end
      
    else
      # We have a caller ID and therefore we can actually perform atomic action
      
      call = Call.find(call_id)
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