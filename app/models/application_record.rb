# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
