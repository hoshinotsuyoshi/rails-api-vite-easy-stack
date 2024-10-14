class CreatePurchases < ActiveRecord::Migration[8.0]
  def change
    create_table :purchases, id: :uuid do |t|
      t.references :cart, null: false, type: :uuid
      t.timestamps
    end
  end
end
