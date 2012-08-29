class User < ActiveRecord::Base
  include CanCan::Ability
  
  @@router = UrlOutputter.new
  
  AVAILABILITY = ["Yes", "No"]
  CONTACT = ["Email", "Text"]
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name,
                  :phone, :priority, :availability, :means_of_contact, :admin
  
  has_many :calls

  #Toggle method which allows an agent to switch their availability
  #status when calling in
  def toggle_availability!
    if not self.available? or self.availablity == nil
      self.availability = "Yes"
    else
      self.availability = "No"
    end
    self.save
  end
  
  #Check to see if the agent is available and not in a call
  def available?
    if self.availability != "Yes" and not locked?
      return false
    end
    return true
  end
  
  #Find all agents who are available
  def self.available
    order("priority").where(:availability => "Yes")
  end
  
  #The twilio object will perform a method connecting an agent to a customer
  def accept_call(call)
    if self.available?
      self.lock_agent
      $twilio_client.account.calls.create(
        :from => "+16023888925",
        :to => "#{self.phone}",
        :url => @@router.patch_agent_call_handler_url(:format => :xml, :call_id => call.id),
        :method => "GET"
      )
    end
  end
  
  
  def display_name
    return (name ? name : email)
  end
  
  #method remove locks on an agent
  def self.delete_lock!
    $redis.del(*$redis.keys("agent:*"))
  end

  #When an agent enters a call, they will be locked so that another customer
  #cannot contact him in the middle of a call
  def lock_agent
    $redis.setex("agent:#{self.id}:locked", 600, "1")
  end
  
  #Checks to see if an agent is in the middle of a call
  def locked?
    $redis.exists("agent:#{self.id}:locked")
  end
  
  #When a call ends, the agent will be unlocked so that he may be re-entered into
  #the call queue
  def unlock_agent
    $redis.del("agent:#{self.id}:locked")
  end
  
  def email=(value)
    if value.is_a?(String)
      super(value.downcase.strip)
    end
  end
  
  def self.prioritize(params)
    params[:users].each_with_index do |user_id, index|
      user = User.find(user_id)
      user.update_attribute(:priority, index)
    end
  end
  
end
