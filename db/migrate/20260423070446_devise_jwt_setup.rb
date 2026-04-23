class DeviseJwtSetup < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_denylist do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
    end
    add_index :jwt_denylist, :jti

    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_index :users, :email, unique: true
  end
end
