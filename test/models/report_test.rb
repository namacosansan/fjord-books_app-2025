# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'ユーザーとターゲットユーザーは同じか' do
    user = User.new(name: 'Alice')
    report = Report.new(user: user)
    assert_equal true, report.editable?(user)
  end

  test '別のユーザーは日報を編集できない' do
    user = User.new(name: 'Alice')
    other_user = User.new(name: 'Bob')
    report = Report.new(user: user)

    assert_equal false, report.editable?(other_user)
  end

  test 'created_onは作成日を返す' do
    report = Report.new(
      created_at: Time.zone.local(2026, 11, 15, 0, 30)
    )

    assert_equal Date.new(2026, 11, 15), report.created_on
  end

  test '本文に日報URLがあるとき言及先が保存される' do
    report = reports(:report_a)

    report.update!(
      content: 'http://localhost:3000/reports/100'
    )

    assert_includes report.mentioning_reports.ids, 100
  end

  test '本文から日報URLを削除すると言及先も削除される' do
    report = reports(:report_a)

    report.update!(
      content: 'http://localhost:3000/reports/100'
    )
    assert_includes report.mentioning_reports.ids, 100

    report.update!(
      content: 'URLを削除しました'
    )
    assert_empty report.mentioning_reports.reload
  end

  test '同じ日報URLが複数あっても言及先は重複しない' do
    report = reports(:report_a)

    report.update!(
      content: 'http://localhost:3000/reports/100 http://localhost:3000/reports/100'
    )

    assert_equal [100], report.mentioning_reports.ids
  end
  test '自分自身の日報URLは言及先に登録されない' do
    report = reports(:report_a)

    report.update!(
      content: "http://localhost:3000/reports/#{report.id}"
    )

    assert_empty report.mentioning_reports
  end
end
