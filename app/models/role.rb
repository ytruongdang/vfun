class Role < ActiveRecord::Base
	has_many :users
	after_initialize :init

	private 
		def init
			self.name ||= 'member'
		end
end
