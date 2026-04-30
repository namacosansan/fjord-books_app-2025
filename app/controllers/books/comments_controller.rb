# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  before_action :set_book
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @book.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back fallback_location: root_path, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @comments = @book.comments.order(created_at: :desc)
      render 'books/show', status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_back fallback_location: root_path, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_comment
    @comment = @book.comments.find(params[:id])
    head :forbidden unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
