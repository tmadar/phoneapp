class AddUserIdToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :user_id, :integer
  end
end
