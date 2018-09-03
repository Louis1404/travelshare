class AddColumnToWays < ActiveRecord::Migration[5.2]
  def change
    add_column :ways, :duration, :integer
  end
end
