# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:one)
  end

  test '本一覧を表示できる' do
    login
    visit books_url
    assert_selector 'h1', text: '本の一覧'
  end

  test '本を作成できる' do
    login
    visit books_url
    click_on '本の新規作成'

    fill_in 'タイトル', with: 'システムテストの学習'
    fill_in 'メモ', with: 'Capybaraを使って本を作成しました'

    assert_difference 'Book.count', 1 do
      click_button '登録する'
      assert_current_path %r{\A/books/\d+\z}
      assert_text 'システムテストの学習'
    end
  end

  test '本を編集できる' do
    login
    visit book_url(@book)
    click_on 'この本を編集'

    fill_in 'タイトル', with: 'システムテストの編集'
    fill_in 'メモ', with: 'Capybaraを使って本を編集しました'

    click_button '更新する'

    assert_current_path book_path(@book)

    assert_text 'システムテストの編集'
    assert_text 'Capybaraを使って本を編集しました'
  end

  test '本を削除できる' do
    login
    visit book_url(@book)
    assert_difference 'Book.count', -1 do
      click_on 'この本を削除'
      assert_selector 'h1', text: '本の一覧'
    end

    assert_no_text @book.title
  end
end
