class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :call_sid
      t.string :phone_number
      t.string :contact_number
      t.string :question
      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
