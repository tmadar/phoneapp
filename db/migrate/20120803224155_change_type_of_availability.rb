class ChangeTypeOfAvailability < ActiveRecord::Migration
  def change
    change_column :users, :availability, :string, :default => ""
  end
end
