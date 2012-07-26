xml.instruct!
xml.Response do
    xml.Say "Hello, thanks for calling Levy On!"
    xml.Say "Unfortunately, there is a wait to speak to a representative.  
    We have detected your phone number is #{params['Caller'].gsub(/\D+/,'').split("").join(" ")}. If this is incorrect,
    press 1. Otherwise, we will call you back. You may leave a short message after the tone."
    xml.Dial  do
      xml.Conference {:beep => "false", :waitUrl => "http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient"} do 
        "Test"
      end
    end
end