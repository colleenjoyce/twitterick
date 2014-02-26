Twitterick::Application.routes.draw do
  devise_for :users
  root :to => "poems#index"  
  resources :poems
end
