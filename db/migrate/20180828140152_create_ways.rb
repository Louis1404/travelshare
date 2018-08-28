class CreateWays < ActiveRecord::Migration[5.2]
  def change
    create_table :ways do |t|
      t.string :departure_city
      t.string :arrival_city
      t.integer :price
      t.text :link
      t.text :content
      t.integer :travel_time
      t.references :traveller, foreign_key: true

      t.timestamps
    end
  end
end
