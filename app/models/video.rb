class Video < ActiveRecord::Base
	belongs_to :user
	belongs_to :attachment
	has_many :likes
	has_many :taggings, :dependent => :destroy
	has_many :tags, through: :taggings

	before_create :get_video_id

	after_initialize :init

	validates :user_id, presence: true
	validates :title, presence: true
	validates :video_id, presence: true, unless: ->(video){ video.attachment_id.present? }
	scope :most_viewd, ->{where(status: 'published').order(viewed: :desc).limit(10)}
	scope :relate, ->(id, tag_ids){ joins(:taggings).where(taggings: { tag_id: tag_ids }).where.not(id: id).where(status: 'published').limit(10) }
	scope :published, ->{ where(status: 'published').order(updated_at: :desc) }
	scope :video_draf, ->{ where(status: nil).order(created_at: :desc) }
	scope :most_liked, ->{ where(status: 'published').order(liked: :desc).limit(10) }
  	scope :recent, ->{ order("created_at desc") }
	validates :attachment_id, presence: true, unless: ->(video){ video.video_id.present? }
	scope :list_by_user, ->(user_id){ where(user_id: user_id) }
	def get_video_id
		youtube = /youtube.com.*(?:\/|v=)([^&$]+)/
	    if video = self.video_id.match(youtube)
	      self.video_type = "youtube"
	      self.video_id = video[1]
	    elsif video_gag = self.video_id.match(/img-9gag-fun.9cache.com\/photo\/(.+)v\.[^.]*$/)
	      self.video_type = "9gag"
	      self.video_id = video_gag[1]
	    elsif self.attachment_id
	      self.video_type = "upload"     
	    else
	      false 
	    end
	end
	def init
	    self.liked || 0
	    self.disliked || 0
	end
	  
	  #update viewed
	  
	def update_viewed
	    old_viewed = (self.viewed ? self.viewed : 0)
	    self.record_timestamps = false
	    self.update_attribute(:viewed, old_viewed + 1)
	    self.record_timestamps = false
	end
	  
	def update_like(action = false)
	    self.record_timestamps = false
	    liked = (self.liked ? self.liked + 1 : 1)
	    if action
	      update_attribute(:liked, liked)
	    else
	      dislike = (self.disliked && self.disliked > 0 ? self.disliked - 1 : 0)
	      update_attributes(:liked => liked, :disliked => dislike)
	    end
	    self.record_timestamps = false
	end
	  
	def update_dislike(action = false)
	    self.record_timestamps = false
	    dislike = (self.disliked ? self.disliked + 1 : 1)
	    if action
	      update_attribute(:disliked, dislike)
	    else
	      liked = (self.liked && self.liked > 0 ? self.liked - 1 : 0)
	      update_attributes(:liked => liked, :disliked => dislike)
	    end
	    self.record_timestamps = false
	end
	  # tag function
	  
	def self.tagged_with(name)
	    Tag.find_by_name!(name).videos
	end
	  
	def tag_list
	    tags.map(&:title).join(", ")
	end
	  
	def tag_list=(names)   
	    self.tags = names.split(",").map do |n|
	      Tag.where(title: n.strip).first_or_create!
	    end
	end
end
