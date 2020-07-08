Rails.application.routes.draw do
  get 'search/search_profiles'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :profiles
      get 'search', action: 'search_profiles', controller: 'search'
    end
  end
end
