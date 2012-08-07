class Record < ActiveRecord::Base
  # attr_accessible :title, :body
    has_many :calls, :autosave => true, :dependent => :destroy
    
    def self.update_page(params)
      call.last_comment = params[:comment]
      return call
    end


end
