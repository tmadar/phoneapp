xml.instruct!
xml.Response do
  if params[:RecordingDuration]
    xml.Say "We have successfully saved your message. A representative will get back to you. Thank you. Please wait if you wish to speak to a representative."
    xml.Redirect({:method => "GET"}, conference_queue_call_handler_url(:format => :xml)) 
  else
    xml.Say "Please re cord your message now followed by the pound key"
    xml.Record({:timeout => "20", :action => leave_message_call_handler_url(:format => :xml), :finishOnKey => "#", :method => "GET"}) do
    end
  end
end

# https://api.twilio.com/2010-04-01/Accounts/ACea16f0f349ef99c4c11c216735185678/Recordings/RE689d103161bab5a59f4f9fe618f6b21a
# https://api.twilio.com/2010-04-01/Accounts/ACea16f0f349ef99c4c11c216735185678/Recordings/RecordingUri.wav