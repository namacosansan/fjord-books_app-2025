Rails.application.routes.draw do
  scope '(:locale)' do
    resources :books
    root 'books#index'
  end
end

