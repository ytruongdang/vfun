require "rubygems"
require "streamio-ffmpeg"
module VideosHelper
	def render_video(url, file_name, type)
	    video = url.split('?')
	    name = file_name.sub /\.[^.]*$/ , ""
	    folder = video[0].split(name)
	  	movie = FFMPEG::Movie.new(video[0])
	    movie.screenshot(folder[0] +"/"+ name + ".jpg")
	end

	def get_dimention(file)
	    video = file.split('?')
	    movie = FFMPEG::Movie.new(video[0])
	    return JSON.generate({'width' => movie.width, 'height'=> movie.height})
	end
end
