class AddDefaultValueToPriority < ActiveRecord::Migration
  def up
      change_column :users, :priority, :integer, :default => 0
  end

  def down
      change_column :users, :priority, :integer, :default => 0
  end
end
