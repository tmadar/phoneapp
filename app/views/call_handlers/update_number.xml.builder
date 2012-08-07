xml.instruct!
xml.Response do
  if params[:Digits] and params[:Digits].size > 1
    xml.Say "We updated your telephone number to #{@call.caller.gsub(/\D+/,'').split("").join(" ")}! "
    xml.Say "Please wait while we try to connect you to an agent..."
    xml.Redirect({:method => "GET"}, conference_queue_call_handler_url(:format => :xml)) 
  else
    xml.Gather({:timeout => "2", :action => update_number_call_handler_url(:format => :xml), :finishOnKey => "#", :method => "GET"}) do 
      xml.Say "Please enter your phone number now, followed by the pound key."
    end
    xml.Say "You did not follow instructions. Goodbye."
  end
end