class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_logged?, :permission?, :controller?, :action?, :get_name, :get_dimention_image, :rend_dimention_video, :image_content
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def user_logged?
    !!current_user 
  end
  
  def permission?
    user = current_user.role.name if current_user
    if user == 'admin'
      true
    else
      false
    end
  end
  
  def action?(*action)
    action.include?(params[:action])
  end
  
  def controller?(*controller)
    controller.include?(params[:controller])
  end
  
  def get_name(file_name, url)
    if file_name != nil && url != ''
      name = file_name.sub /\.[^.]*$/ , ""
      folder = url.split(name)
      return folder[0]+name
    else
      return folder = "404.png"
    end
  end

  def get_dimention_image(video_id)
    image = MiniMagick::Image.open("http://img-9gag-fun.9cache.com/photo/" + video_id + ".jpg")
    height = image.height
    width = image.width
    return JSON.generate({"height" => height, "width"=> width})
  end

  def rend_dimention_video(data)
    if data != nil
      dimention = JSON.parse(data)
      if dimention['width']/dimention['height'] >= 0.8
        return {'width'=> '100%', 'height' => 'auto'}
      elsif dimention['height'] <= 600
        return {'width'=> 'auto', 'height' => "#{dimention['height']*1.2} px"}
      else
        return {'width'=> 'auto', 'max-height' => '600px'}
      end
      # return dimention
    end
      return {'width'=> 'auto', 'height' => 'auto'}
  end
  def image_content(video)
    if video.video_type == "youtube"
      return "http://i.ytimg.com/vi/#{video.video_id}/hqdefault.jpg"
    elsif video.video_type == "9gag"
      return "http://img-9gag-fun.9cache.com/photo/#{video.video_id}.jpg"
    elsif video.video_type == "upload"
      return "http://video4l" + get_name(video.attachment.video_file_name, video.attachment.video.url) + ".jpg"
    else
      return ""
    end
  end
end
