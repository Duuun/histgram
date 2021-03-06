class PostsController < ApplicationController

  before_action :authenticate_user, {only: [:new, :create, :edit, :destroy]}
  before_action :ensure_correct_user, {only: [:update, :destroy]}

  def index
    @post = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      content: params[:post][:content],
      image: params[:post][:image],
      user_id: @current_user.id
    )
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to("/")
    else
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/")
  end

  # TODO
  def search
    @post = Post.search(params[:search])
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
