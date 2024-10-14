class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts, id: :uuid do |t|
      t.references :user, null: false, type: :uuid
      t.timestamps
    end
  end
end
