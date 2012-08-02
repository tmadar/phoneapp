class AddCallIndexToComments < ActiveRecord::Migration
    add_index :comments, :call_id
end
