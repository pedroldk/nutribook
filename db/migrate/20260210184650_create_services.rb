class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.string :name
      t.decimal :price
      t.string :location
      t.float :latitude
      t.float :longitude
      t.references :nutritionist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
