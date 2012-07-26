class AddToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :priority, :integer
    add_column :users, :availability, :boolean
    add_column :users, :means_of_contact, :string
    add_column :users, :admin, :boolean
  end
end
