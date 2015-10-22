class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @videos = Video.list_by_user(@user.id).published.paginate(page: params[:page], per_page: 10)
    @populare = Video.most_viewd
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    role = Role.find_by_name('member')
    @user = role.users.new(user_params)

    respond_to do |format|
      if @user.save
        UserMailer.registration_confirmation(@user).deliver
        flash[:success] = "Bạn đã đăng ký thành công!Bạn vui lòng vào mail để chứng thực tài khoản"
        session[:user_id] = @user.id
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def confirm_mail
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_active
      flash[:success] = "Welcome to Video4l.com! Your email has been confirmed"
      redirect_to login_path
    else
      flash[:warning] = "Sorry, User does not exist"
      redirect_to root_path
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
