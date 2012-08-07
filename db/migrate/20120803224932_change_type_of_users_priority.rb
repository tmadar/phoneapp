class ChangeTypeOfUsersPriority < ActiveRecord::Migration
  def up
    change_column :users, :priority, :string, :default => "0"
  end

  def down
      change_column :users, :priority, :string, :default => "0"
  end
end
