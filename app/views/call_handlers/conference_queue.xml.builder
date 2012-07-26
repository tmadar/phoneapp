xml.instruct!
xml.Response do
    xml.Dial do
      xml.Conference({:beep => "false", :waitUrl => "http://twimlets.com/holdmusic?Bucket=com.twilio.music.electronica"}, "Conference_Call_#{@call.id}") 
    end
end