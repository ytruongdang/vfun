class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  include VideosHelper
  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.published.paginate(page: params[:page], per_page: 10)
    @populare = Video.most_viewd
  end
  # GET /videos
  # GET /videos.json
  def most_viewed
    @videos = Video.most_viewd.paginate(page: params[:page], per_page: 10)
    @populare = Video.most_viewd
  end

  def draf
    role = current_user.role.name
    if role == 'admin'
      @videos = Video.video_draf.paginate(page: params[:page], per_page: 10)
    else
      flash[:warning] = "You dont has permission"
    end
  end
  def published
    role = current_user.role.name
    if role == 'admin'
      post = Video.find(params[:id])
      if post.update_attribute(:status, 'published')
        flash[:success] = "Publish"
        redirect_to :back
      else
        flash[:warning] = "Some errors"
        redirect_to :back
      end
    else
      flash[:warning] = "You don't have permission"
      redirect_to :back
    end
  end
  
  def edit
    @video = Video.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
    else
      redirect_to :back
    end
  end
  
  #like action
  def like
    if user_logged?
      @video = Video.find(params[:id])
      like = Like.create(user_id: current_user.id, video_id: @video.id, liked: true)
      if like.valid?
        @video.update_like(true)
      else
        
        check = Like.check_availiable(current_user.id, @video.id)
        if !check.liked
          @video.update_like
          check.update_attribute(:liked, true)
        end
      end
      respond_to do |format|
        format.json { render json: @video }
      end
    else
      @erorrs = {:message => 'hihie', :path => login_path}
      respond_to do |format|
        format.json { render json: @erorrs }
      end
    end
  end
  
  def dislike
    if user_logged?
      @video = Video.find(params[:id])
      like = Like.create(user_id: current_user.id, video_id: @video.id, liked: true)
      if like.valid?
        @video.update_dislike(true)
      else
        check = Like.check_availiable(current_user.id, @video.id)
        if check.liked
          @video.update_dislike
          check.update_attribute(:liked, false)
        end
      end
      respond_to do |format|
        format.json { render json: @video }
      end
    else
      @erorrs = {:message => 'hihie', :path => login_path}
      respond_to do |format|
        format.json { render json: @erorrs }
      end
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])
    @populare = Video.relate(@video.id, @video.tag_ids)
    @video.update_viewed
  end

  # GET /videos/new
  def new
    if user_logged?
      if current_user.email_confirmed
        @video = Video.new
      else
        flash[:warning] = "Tài khoản của bạn chưa được xác thực.Xin bạn vào email click vào link để xác thực tài khoản"
        redirect_to root_path
      end
    else
      redirect_to dang_nhap_path
    end
  end

  # POST /videos
  # POST /videos.json
  def create
    # abort(params.inspect)
    if params[:video] && params[:commit] == nil
      @attachment = Attachment.new(upload_params)
      if @attachment.save
        render_video(@attachment.video.path, @attachment.video_file_name, @attachment.video_content_type)
        @attachment.update_attribute(:dimention, get_dimention(@attachment.video.path))
        respond_to do |format|
          format.json { render json: @attachment }
        end
      else        
        respond_to do |format|
          format.json { render json: @attachment }
        end
      end
    else
      @video = current_user.videos.new(video_params)
      respond_to do |format|
        if @video.save
          if @video.video_type == "9gag"
            @video.update_attribute(:dimention, get_dimention_image(@video.video_id))
          end
          format.html { redirect_to @video }
          format.json { render :show, status: :created, location: @video }
        else
          format.html { render :new }
          format.json { render json: @video.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    if permission?
      respond_to do |format|
        if @video.update(video_params)
          format.html { redirect_to @video }
          format.json { render :show, status: :ok, location: @video }
        else
          format.html { render :edit }
          format.json { render json: @video.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:warning] = "You can not do this action"
    end
  end
  def tags_ajax
    taglist = Tag.find_tag_like(params[:q])
    #abort(taglist.inspect)
    @tags_list = []
    if taglist
      taglist.each do |t|
        @tags_list.push(t.title)
      end
    end
    respond_to do |format|
      format.json { render json: @tags_list }
    end
  end
  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    if permission?
      # @video = Video.find(params[:id])
      @video.destroy
        respond_to do |format|
        format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      flash[:warning] = "You don't have permission"
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:title, :video_id, :description, :tag_list, :attachment_id)
    end

    def upload_params
      params.require(:video).permit(:video)
    end
    def require_login
      redirect_to login_path if !user_logged?
    end
end
