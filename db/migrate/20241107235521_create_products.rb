class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
