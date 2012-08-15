xml.instruct!
xml.Response do
  if params[:Digits]
    xml.Say "You have determined the call to be successful."
    xml.Say "The call is over."
  else
    xml.Gather({:numDigits => 1, :timeout => "20", :action => unlock_agent_call_handler_url(:format => :xml), :method => "GET"}) do
      xml.Say "If your call was solved, please press any key. Otherwise, the call will be considered open."
    end
  end
end
