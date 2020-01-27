Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html



  namespace 'api' do
  	namespace 'v1' do
      resources :transfers, only: [:create]
      resources :accounts, only: [:create] do
        post :balance, on: :collection
      end
  	end
  end

end
