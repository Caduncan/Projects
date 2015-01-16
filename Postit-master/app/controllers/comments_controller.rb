class CommentsController < ApplicationController
  before_action :login_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.new(comment_params) # TODO : app crash when comment body empty
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = 'Your comment was added.'
      redirect_to post_path(@post)
    else
      @post.reload
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    respond_to do |format|
      if @vote.valid?
        flash[:notice] = 'Your vote was counted'
        format.html { redirect_to :back }
        format.js
      else
        flash[:error] = 'You can only vote on a comment once.'
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end