class RemoveLocationFromNutritionists < ActiveRecord::Migration[8.1]
  def change
    remove_column :nutritionists, :address, :string
    remove_column :nutritionists, :latitude, :float
    remove_column :nutritionists, :longitude, :float
  end
end
