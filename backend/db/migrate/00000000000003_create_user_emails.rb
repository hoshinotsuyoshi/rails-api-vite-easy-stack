class CreateUserEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :user_emails, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :email_address, null: false
      t.datetime :confirmed_at

      t.timestamps
    end

    add_index :user_emails, :email_address, unique: true
  end
end
