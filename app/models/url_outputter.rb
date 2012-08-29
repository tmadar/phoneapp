class UrlOutputter
  include Rails.application.routes.url_helpers
  
  #Rails will create the url to allow the patching of agents to customers
  def default_url_options
    ActionMailer::Base.default_url_options
  end
  
end