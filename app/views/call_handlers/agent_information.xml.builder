xml.instruct!
xml.Response do
  if params[:Digits] and params[:Digits].size >= 1
    xml.Say "Your availability has been changed. Thank you. Good bye."
  else
    xml.Gather({:timeout => "5", :numDigits => "1", :action => agent_information_call_handler_url(:format => :xml), :method => "GET"}) do 
      xml.Say "You are currently #{@call.user.available? ? "active" : "inactive"}. If you would like to change your availability to #{@call.user.available? ? "inactive" : "active"}, press 1."
    end
    xml.Say "You did not change your status. Call back again to do so."  
  end
end