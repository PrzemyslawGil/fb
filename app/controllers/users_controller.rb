class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destoy]

  def new
    @user = User.new
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and corresponding article destroyed"
    redirect_to articles_path
  end

  def create
    @user = User.new(user_params)
     if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to sports blog"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated sucessfully"
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def show
    @users_articles = @user.articles.paginate(:page => params[:page], :per_page => 5)
  end

  def index
    @users = User.paginate(:page => params[:page], :per_page => 5)
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "you can edit only your own account"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_ib? and !current_user.admin?
      flash[:danger] = "Only admin user can do that action"
      redirect_to root_path
    end
  end
end