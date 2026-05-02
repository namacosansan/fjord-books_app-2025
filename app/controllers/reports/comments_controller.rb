# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  before_action :set_report
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @comments = @report.comments.order(created_at: :desc)
      render 'reports/show', status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @report, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.expect(comment: [:body])
  end
end
