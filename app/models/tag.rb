class Tag < ActiveRecord::Base
	has_many :taggings
	has_many :videos, through: :taggings

	scope :find_tag_like, ->(name){ where("title like ?", "#{name}%") }
end
