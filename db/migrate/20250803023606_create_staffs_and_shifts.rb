class CreateStaffsAndShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :shifts do |t|
      t.references :staff, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.timestamps
    end

    add_index :shifts, :start_time
  end
end
