# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '名前があるがある場合は名前を返す' do
    user = User.new(
      name: 'Alice',
      email: 'alice@example.com'
    )

    assert_equal 'Alice', user.name_or_email
  end
  test '名前がない場合はemailを返す' do
    user = User.new(
      name: '   ',
      email: 'alice@example.com'
    )

    assert_equal 'alice@example.com', user.name_or_email
  end
end
