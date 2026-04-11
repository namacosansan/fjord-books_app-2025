# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.order(:id).page(params[:page])
  end

  def show
    @comments = @book.comments.order(created_at: :desc)
  end

  def new
    @book = Book.new
  end

  def edit; end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to @book, notice: t('controllers.common.notice_create', name: Book.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: t('controllers.common.notice_update', name: Book.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy!
    redirect_to books_path, status: :see_other, notice: t('controllers.common.notice_destroy', name: Book.model_name.human)
  end

  private

  def set_book
    @book = Book.find(params.expect(:id))
  end

  def book_params
    params.expect(book: %i[title memo author picture])
  end
end
