class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|

      t.timestamps
    end
  end
end
