class AddDefaultValueToBodyAttribute < ActiveRecord::Migration
  def up
      change_column :comments, :body, :text, :default => ""
  end

  def down
      change_column :comments, :body, :text, :default => ""
  end
end
