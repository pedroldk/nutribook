class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.string :guest_name
      t.string :guest_email
      t.datetime :start_time
      t.integer :status
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
