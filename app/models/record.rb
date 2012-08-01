class Record < ActiveRecord::Base
  # attr_accessible :title, :body
    has_many :calls, :autosave => true, :dependent => :destroy


end
