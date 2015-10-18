class Like < ActiveRecord::Base
	belongs_to :user
	belongs_to :video

	validates_uniqueness_of :user, scope: :video

	def self.check_availiable(user_id, video_id)
		where("user_id = #{user_id} AND video_id = #{video_id}").first
	end
end
