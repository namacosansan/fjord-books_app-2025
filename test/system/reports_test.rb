# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:report_a)
  end

  test '日報一覧を表示できる' do
    login

    visit reports_url

    assert_selector 'h1', text: '日報の一覧'
  end

  test '日報を作成できる' do
    login

    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'システムテストの学習'
    fill_in '内容', with: 'Capybaraを使って日報を作成しました'

    assert_difference 'Report.count', 1 do
      click_button '登録する'
      assert_current_path %r{\A/reports/\d+\z}
      assert_text 'システムテストの学習'
    end
  end

  test '日報を編集できる' do
    login
   
    visit report_url(@report)
    
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'システムテストの編集'
    fill_in '内容', with: 'Capybaraを使って日報を編集しました'
    

    click_button '更新する'
    assert_current_path report_path(@report)
   
    assert_text 'システムテストの編集'
    assert_text 'Capybaraを使って日報を編集しました'
  end

  test '日報を削除できる' do
    login

    visit report_url(@report)

    assert_difference 'Report.count', -1 do
      click_on 'この日報を削除'
      assert_selector 'h1', text: '日報の一覧'
    end

    assert_no_text @report.title
  end
end
