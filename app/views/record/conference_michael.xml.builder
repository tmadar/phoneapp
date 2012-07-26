xml.instruct!
xml.Response do
    xml.Say "Hi, we have a caller waiting to talk to you!"
    xml.Dial :beep => "false" do
      xml.Conference "Test"
    end
end