class LoginsController < ApplicationController
	def new
		redirect_to videos_path if user_logged?
	end

	def create
		user = User.check_user(params[:username]).first
	    # abort(user.inspect)
	    if user && user.authenticate(params[:password])
	      session[:user_id] = user.id
	      flash[:success] = "Chào mừng bạn quay trở lại #{user.username}, have fun!"
	      redirect_to :back
	    else
	      flash[:danger] = "Email or password are incorrect"
	      redirect_to dang_nhap_path
	    end
	end

	def destroy
		session[:user_id] = nil
    	redirect_to videos_path
	end
end
