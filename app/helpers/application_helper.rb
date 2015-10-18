module ApplicationHelper
	require 'digest/md5'  
  
	def gravatar_url_for(user, options = { size: 80 })  
		gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.username, class: "gravatar")
	end

	def meta_tag(tag, text)
		content_tag :"meta_#{tag}", text
	end

	def yield_meta_tag(tag, default_text='')
		content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
	end
end
