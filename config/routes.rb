Twitterick::Application.routes.draw do
  devise_for :users
  root :to => "poems#index"  
  resources :poems do 
  	post :like 
  end
  get "/twitter_handles/new" => "twitter_handles#new"
  post "/twitter_handles" => "twitter_handles#create"
end
