Rails.application.routes.draw do
  resources :rooms, controller: "rooms/main", only: [] do
    post :paint, on: :collection
  end
end
