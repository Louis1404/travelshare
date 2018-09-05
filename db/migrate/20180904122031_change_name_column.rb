class ChangeNameColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :ways, :duration, :distance
  end
end
