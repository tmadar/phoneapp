xml.instruct!
xml.Response do
  if params[:Digits] and params[:Digits].size > 0
    xml.Say "Connecting you now!"
    xml.Dial do
      xml.Conference({:beep => "false", :endConferenceOnExit => "true", :waitUrl => "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical"}, "Conference_Call_#{@customer_call.id}")
    end
    xml.Redirect({:method => "GET"}, unlock_agent_call_handler_url(:agent_id => @call.user.id, :format => :xml)) 
  elsif not params[:next_agent]
    xml.Gather({:numDigits => "1", :timeout => "5", :method => "GET", :action => patch_agent_call_handler_url(:call_id => @customer_call.id, :format => :xml)}) do 
      xml.Say "If you would like to take the call from #{@customer_call.caller.to_s.gsub(/\D+/,'').split("").join(" ")}, Press any key now."
    end
    xml.Redirect({:method => "GET"}, patch_agent_call_handler_url(:agent_call_id => @call.id,:call_id => @customer_call.id, :next_agent => true, :format => :xml)) 
  else
    xml.Say "Goodbye."
  end
end