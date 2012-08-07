class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  include CanCan::Ability
  
  AVAILABILITY = ["Yes", "No"]
  CONTACT = ["Phone", "Text"]
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name,
                  :phone, :priority, :availability, :means_of_contact, :admin
  # attr_accessible :title, :body
  

  def toggle_availability!
    if not self.available?
      self.availability = "Yes"
    else
      self.availability = "No"
    end
    self.save
  end
  
  def available?
    if self.availability != "Yes"
      return false
    end
    return true
  end
  
end
