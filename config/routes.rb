Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :account

  resources :sessions, only: [:new, :create, :destroy]

  root :to => 'test#test'

  #ACCOUNT
  post '/account/new', to: 'account#new'
  get  '/login', to: 'account#login'
  get  '/account/:id/reqpass', to: 'account#reqpass'
  get  '/confirmation/login', to: 'account#currentUser'
  get  'recover/account', to: 'account#accountrecover'
  post '/recover/pin', to: 'account#pinrecover'
  get  '/recover/confirmpin', to: 'account#confirmcode'
  post '/account/confirm', to: 'account#emailconfirm'
  post '/account/confirm/code', to: 'account#emailconfirmcode'
  post '/account/passupdate', to: 'account#passupdate'
  post '/account/:id/edit', to: 'account#edit'
  post '/account/:id/delete', to: 'account#delete'
  get '/account/:id/info', to: 'account#userInfo'
  get '/account/search', to: 'account#search'
  #get 'logout', to: 'sessions#destroy', as: 'logout'

  #MAP
  get '/account/places/search', to: 'maps#searchPlaces'
  get '/account/spot/:placeid', to: 'maps#spotInfo'
  get '/account/:id/from/:origin/to/:destination', to: 'maps#buildRoute'
  post '/account/:id/from/:origin/to/:destination/start', to: 'maps#startRoute' #save route and boolean to check wheather route was completed or no
  
  #FAMILIES
  get '/account/families', to: 'family#index'
  post '/account/new_family', to: 'family#create'
  get '/account/invite', to: 'family#sendInvitation'


  #FAVORITES
  get '/account/:id/favorites', to: 'fav#index'
  post '/account/:id/favorites/new', to: 'fav#create'

  #CONTACTS
  get '/account/:id/contacts', to: 'contact#index'

end
