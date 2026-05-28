class AddUniqueIndexToReportMentions < ActiveRecord::Migration[8.0]
  def change
    add_index :report_mentions,
              %i[mentioning_report_id mentioned_report_id],
              unique: true
  end
end
