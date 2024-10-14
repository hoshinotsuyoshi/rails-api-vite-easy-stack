class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items, id: :uuid do |t|
      t.references :cart, null: false, type: :uuid
      t.references :product, null: false, type: :uuid
      t.string :product_name, null: false # NOTE: yes, it is redundant but product's name snapshot is needed.
      t.decimal :product_unit_price, null: false, default: 0 # NOTE: yes, it is redundant but product's unit_price snapshot is needed.
      t.integer :quantity, null: false, default: 0
      t.timestamps
    end
  end
end
