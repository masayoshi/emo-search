class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :nicovideo_id, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :thumbnail_url, null: false
      t.datetime :first_retrieve, null: false
      t.string :length, null: false
      t.integer :view_counter, null: false
      t.integer :comment_num, null: false
      t.integer :mylist_counter, null: false
      t.string :watch_url, null: false
      t.string :nicovideo_user_id, null: false

      t.timestamps
    end

    add_index :videos, :nicovideo_id, unique: true
    add_index :videos, :first_retrieve
  end
end
