class CreateSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :seats do |t|
      t.integer     :number, null: false
      t.boolean     :is_used, default: false, null: false

      t.timestamps
    end
  end
end
