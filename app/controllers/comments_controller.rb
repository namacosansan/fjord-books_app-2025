class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[destroy]
  before_action :authorize_comment_owner!, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back fallback_location: root_path, notice: "コメントを追加しました。"
    else
      render_commentable_show_with_errors
    end
  end

  def destroy
    comment = @commentable.comments.find(params[:id])
    comment.destroy
    redirect_back fallback_location: root_path, notice: "コメントを削除しました。"
	end

  private

  # ★ ポイント：ここで「どのモデルに紐づくコメントか」を判定する
  def set_commentable
    # params の中から *_id を探す汎用パターン
    klass = nil
    id    = nil

    params.each do |name, value|
      if name.to_s =~ /(.+)_id$/
        klass = $1.classify.constantize  # "report" → Report
        id    = value
        break
      end
    end

    @commentable = klass.find(id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def authorize_comment_owner!
    redirect_to reports_path, alert: 'コメントを消す権限がありません' unless @comment.user == current_user
  end

  def render_commentable_show_with_errors
    if @commentable.is_a?(Book)
      @book = @commentable
      render 'books/show', status: :unprocessable_entity
    elsif @commentable.is_a?(Report)
      @report = @commentable
      render 'reports/show', status: :unprocessable_entity
    end
  end
end
