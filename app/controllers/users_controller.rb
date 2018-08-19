class UsersController < ApplicationController
  
  include SessionsHelper
  
  before_action :require_user_logged_in, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :DESC).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザーを登録しました"
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash.now[:danger] = "ユーザーの登録に失敗しました"
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "ユーザー情報の更新に失敗しました。"
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to root_url
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def correct_user
    if @current_user.id != params[:id].to_i
      flash[:danger] = "アクセス権限がありません"
      redirect_to user_path(current_user)
    end
  end
  
end
