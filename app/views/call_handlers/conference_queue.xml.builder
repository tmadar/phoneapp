xml.instruct!
xml.Response do
  xml.Dial do
    xml.Conference({:beep => "false", :endConferenceOnExit => "true", :waitUrl => "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical"}, "Conference_Call_#{@call.id}")
  end
end