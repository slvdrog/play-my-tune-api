Rails.application.routes.draw do

  apipie
  resources :artists do
    resources :songs
    resources :albums do 
      resources :songs
    end
  end
  resources :albums do 
    resources :songs
  end
  resources :playlists do
    post 'add/:song_id', to: 'playlists#add_song'
    delete 'remove/:song_id', to: 'playlists#remove_song'
  end
end
