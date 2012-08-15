class UserSyncr
  
  def self.perform
    users = User.all
    zendesk_users = ZendeskUser.all
    
    not_in_zendesk_users = users.reject { |user| zendesk_users.detect { |zu| zu.email.strip.downcase == user.email.strip.downcase } }.reject { |user| user.role == "end-user" }
    
    
    # not_in_zendesk_users.each 
    #   create and save zendesk user
    #   assign membership to hardcoded group
    # end
    
    # clean up AGENTS (not end-users) that don't belong
    # dont_belong.each 
    #    delete user
    # end
  end
  
end
