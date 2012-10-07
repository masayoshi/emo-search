class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :token, null: false
      t.string :secret
      t.string :image_url
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :authentications, :user_id
    add_index :authentications, [:provider, :uid], unique: true
  end
end
