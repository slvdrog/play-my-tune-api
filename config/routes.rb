Rails.application.routes.draw do

  apipie
  resources :artists do
    resources :albums    
    resources :songs    
  end
  resources :albums do
    resources :songs
  end
end
