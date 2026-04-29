class AddCoordinatesToCinemas < ActiveRecord::Migration[8.0]
  def change
    add_column :cinemas, :latitude, :decimal, precision: 10, scale: 6
    add_column :cinemas, :longitude, :decimal, precision: 10, scale: 6
  end
end
