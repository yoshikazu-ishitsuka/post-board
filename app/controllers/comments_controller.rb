class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    # @comment = Comment.create(comment_params)
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントを（140文字以内で）入力してください。"
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
