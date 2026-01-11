I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

# 利用するロケール
I18n.available_locales = [:ja, :en]

# デフォルトロケール（URLにlocale指定がないときに使われる）
I18n.default_locale = :ja
