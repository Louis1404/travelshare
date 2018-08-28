class CreateTravellers < ActiveRecord::Migration[5.2]
  def change
    create_table :travellers do |t|
      t.boolean :organizer
      t.references :profile, foreign_key: true
      t.references :trip, foreign_key: true

      t.timestamps
    end
  end
end
