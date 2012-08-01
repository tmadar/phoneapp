class AddDispositionToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :disposition, :string
  end
end
