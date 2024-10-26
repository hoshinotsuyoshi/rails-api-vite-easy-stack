class CreateUserDatabaseAuthentications < ActiveRecord::Migration[8.0]
  def change
    create_table :user_database_authentications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
