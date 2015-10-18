class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
    	t.integer :user_id
    	t.integer :video_id
      	t.boolean :liked
    end
  end
end
