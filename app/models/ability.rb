class Ability
  include CanCan::Ability

  #Creates user privileges. If you are the admin, you have the ability
  #to change and edit info.
  #If not an admin, you may only view the application, and not edit
  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :sync_with_zendesk, :all
      can :sync_with_app, :all
    end
  end
  
end
