class UserSyncr
  
  def self.gather_users
    @users = User.all
    
    #Store all the users on the zendesk who are not considered
    #to be end-users. These will be the "agents" on the zendesk side
    @zendesk_users = ZendeskUser.all.reject {|user| user.role =="end-user"}
    
    #list of app users to delete based on those in zendesk
    @not_in_zendesk_users = @users.reject { |user| @zendesk_users.detect { |zu| zu.email.strip.downcase == user.email.strip.downcase } }
    
    #list of zendesk users to be deleted based on users found in the app
    @shouldnt_be_in_zendesk_users = @zendesk_users.select { |zendesk_user| not @users.detect { |user| user.email.downcase.strip == zendesk_user.email.downcase.strip } }

  end
  
  def self.sync_with_zendesk
    gather_users
    
    @not_in_zendesk_users.each do |user|
      user.destroy
    end
    
    @zendesk_users.each do |user|
      if not User.exists?(:email => user.email)
        new_user = User.new
        new_user.email = user.email
        new_user.password = "password"
        new_user.password_confirmation = "password"
        new_user.save
      end
    end
    
  end
  
  def self.sync_with_app
    gather_users
    
    @shouldnt_be_in_zendesk_users.each do |user|
      user.active = false
      user.save
    end
    
    # @users.each do |user|
    #   if not ZendeskUser.exists?(:email => user.email)
    #     new_user = ZendeskUser.new
    #     new_user.email = user.email
    #     new_user.role = "agent"
    #     new_user.active = true
    #     if user.name != nil
    #       new_user.name = user.name
    #     else
    #       new_user.name = user.email.gsub(/[a-zA-Z1-9]+[@]/).chomp
    #     end
    #     new_user.save
    #   end
    # end
    
  end
  
end
