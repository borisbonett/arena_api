class AddStockToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :stock, :integer, default: 1
  end
end
