class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :onboarding_status, null: false

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
