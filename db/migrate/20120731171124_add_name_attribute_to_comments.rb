class AddNameAttributeToComments < ActiveRecord::Migration
  def change
    add_column :comments, :name, :string, :default => ""
  end
end
