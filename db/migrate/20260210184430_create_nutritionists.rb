class CreateNutritionists < ActiveRecord::Migration[8.1]
  def change
    create_table :nutritionists do |t|
      t.string :name
      t.string :email
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
