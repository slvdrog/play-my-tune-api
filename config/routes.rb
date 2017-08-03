Rails.application.routes.draw do

  resources :artists do
    resources :albums    
    resources :songs    
  end
end
