class RemoveFirstNameLastNameCityFromProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :first_name, :string
    remove_column :profiles, :last_name, :string
    remove_column :profiles, :city, :string
  end
end
