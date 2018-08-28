class AddLatitudeToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :latitude, :float
  end
end
