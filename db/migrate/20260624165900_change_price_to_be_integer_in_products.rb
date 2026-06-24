class ChangePriceToBeIntegerInProducts < ActiveRecord::Migration[7.1]
  def up
    change_column :products, :price, :integer, using: 'price::integer'
  end

  def down
    change_column :products, :price, :decimal, precision: 10, scale: 2, using: 'price::numeric'
  end
end
