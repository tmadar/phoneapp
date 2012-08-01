class AddDefaultValueToDispositionAttribute < ActiveRecord::Migration
  def up
      change_column :calls, :disposition, :string, :default => "Open"
  end

  def down
      change_column :calls, :disposition, :string, :default => ""
  end
end
