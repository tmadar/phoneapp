class CallStatus
  @queue = :call_status_queue
  
  def self.peform(call_id)
    call = Call.find(call_id)
      twilio_call = $twilio_client.account.calls.get(call.twilio_call_sid)
      call.received_at = twilio_call.start_time
      call.duration = twilio_call.duration
      call.status = twilio_call.status
      call.save
    if calls.empty?
      Resque.remove_delayed(CallStatus)
    end
  end
  
end