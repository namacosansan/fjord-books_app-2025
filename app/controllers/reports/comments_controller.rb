class Reports::CommentsController < ApplicationController
  before_action :set_report
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_back fallback_location: root_path, notice: t('comments.notices.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_back fallback_location: root_path, notice: t('comments.notices.deleted')
  end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def set_comment
    @comment = @report.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
