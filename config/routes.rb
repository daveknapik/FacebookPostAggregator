FacebookPostAggregator::Application.routes.draw do
  root :to => 'facebook_users#index'

  resources :facebook_users, :constraints => { :id => /[^\/]+/ } do
    get 'search', :on => :collection
    resources :posts
  end
end
