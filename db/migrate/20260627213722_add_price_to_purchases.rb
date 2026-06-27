class AddPriceToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :price, :decimal, precision: 12, scale: 0
  end
end
