class AddDeviseToUsuarios < ActiveRecord::Migration[8.0]
  def change
    change_table :usuarios do |t|
      t.string   :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
    end

    add_index :usuarios, :reset_password_token, unique: true
  end
end
