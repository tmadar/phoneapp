class AddCallIdToComments < ActiveRecord::Migration
  def change
        add_column :comments, :call_id, :integer
  end
end
