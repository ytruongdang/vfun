class Attachment < ActiveRecord::Base
	has_many :videos
	has_attached_file :video
	validates_attachment_content_type :video, content_type: ["video/mp4", "video/webm"]
end
