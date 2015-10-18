class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username
    	t.string :email
    	t.string :password_digest
    	t.integer :role_id
    	t.boolean :email_confirmed
      t.string :confirm_token
    	t.timestamps null: false
    end
  end
end
