xml.instruct!
xml.Response do
    xml.Say "Hello, thanks for calling Levy On!"
    xml.Say "Unfortunately, there is a wait to speak to a representative."
    xml.Gather({:timeout => "2", :action => update_number_call_handler_url(:format => :xml), :numDigits => "1", :method => "GET"}) do
      xml.Say "We have detected your phone number is #{params['Caller'].gsub(/\D+/,'').split("").join(" ")}. If this is incorrect,
      press 1."
    end
    xml.Gather({:timeout => "2", :action => leave_message_call_handler_url(:format => :xml), :numDigits => "2", :method => "GET"}) do
      xml.Say "If you would like to leave a message, please press 2."
    end
    xml.Redirect({:method => "GET"}, conference_queue_call_handler_url(:format => :xml)) 
end