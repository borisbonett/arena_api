Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Rutas de Autenticación
      post '/auth/login', to: 'authentication#login'
      post '/auth/register', to: 'users#create'

      # CRUD de Usuarios (Gestionado por Admin o el mismo usuario)
      resources :users, exampt: [:create]

      # CRUD de Productos
      resources :products

      # Ruta para comprar un producto
      post '/buy', to: 'purchases#create'
    end
  end
end
