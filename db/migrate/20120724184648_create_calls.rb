class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :caller
      t.datetime :received_at
      t.integer :duration
      t.string :twilio_call_sid
      t.integer :zendesk_id
      t.datetime :rescheduled_to
      t.string :status
      t.text :last_comment
      t.string :recording
      t.timestamps
    end
  end
end
