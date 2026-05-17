# frozen_string_literal: true

class ReportMention < ApplicationRecord
  belongs_to :mentioning_report,
             class_name: 'Report',
             inverse_of: :active_mentions

  belongs_to :mentioned_report,
             class_name: 'Report',
             inverse_of: :passive_mentions
end
