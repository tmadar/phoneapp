require 'twilio-ruby'

class TwilioInfo
  ACCOUNT_SID = 'ACea16f0f349ef99c4c11c216735185678'
  AUTH_TOKEN = 'fb79bb560d3ab40a659d012e75371583'
end

# set up a client to talk to the Twilio REST API
$twilio_client = Twilio::REST::Client.new TwilioInfo::ACCOUNT_SID, TwilioInfo::AUTH_TOKEN