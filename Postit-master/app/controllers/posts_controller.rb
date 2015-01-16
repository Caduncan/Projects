class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :login_user, except: [:index, :show]
  before_action :creator_user_or_admin, only: [:edit, :update]

  def index
    @posts = sort_voteable(Post.all)

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def show
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:notice] = "Post Created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post Updated."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    respond_to do |format|
      if @vote.valid?
        flash[:notice] = 'Your vote was counted'
        format.html { redirect_to :back }
        format.js
      else
        flash[:error] = 'You can only vote on a post once.'
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private

    def set_post
      @post = Post.find_by(slug: params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :url, :description, category_ids: [])
    end

    def creator_user_or_admin
      unless current_user?(@post.creator) || current_user.admin?
        flash[:error] = "You can't do that."
        redirect_to root_path
      end
    end

end
