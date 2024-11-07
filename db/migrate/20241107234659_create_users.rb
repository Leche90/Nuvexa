class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :role
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
