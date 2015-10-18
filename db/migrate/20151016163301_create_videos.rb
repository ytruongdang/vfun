class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
    	t.string :title
    	t.string :slug
    	t.string :video_id
    	t.string :video_type
    	t.string :dimention
    	t.integer :liked
    	t.integer :disliked
    	t.integer :viewed
    	t.integer :user_id
    	t.string :status
    	t.text :description
        t.integer :upload_id
      	t.timestamps null: false
    end
  end
end
