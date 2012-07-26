class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|

      t.timestamps
    end
  end
end
