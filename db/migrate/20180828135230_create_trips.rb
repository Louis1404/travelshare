class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.text :description
      t.string :title
      t.string :destination

      t.timestamps
    end
  end
end
