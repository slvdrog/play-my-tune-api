Rails.application.routes.draw do

  apipie
  resources :artists do
    resources :albums do 
      resources :songs
    end    
  end
  resources :albums
end
