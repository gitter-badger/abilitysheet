Rails.application.routes.draw do
  get 'sheets/show'

  devise_for :users

  root 'welcomes#index'
  get '/users/list' => 'welcomes#list', as: :list_welcome

  get '/sheets/:iidxid/clear' => 'sheets#clear', as: :clear_sheets
  get '/sheets/:iidxid/hard' => 'sheets#hard', as: :hard_sheets

  get '/scores/:id.:format' => 'scores#attribute', as: :scores
  post '/scores/:id' => 'scores#update', as: :score
  patch '/scores/:id' => 'scores#update'

  get '/logs/:iidxid/list' => 'logs#list', as: :list_logs
  get '/logs/:iidxid/sheet' => 'logs#sheet', as: :sheet_log
  get '/logs/:iidxid/:date' => 'logs#show', as: :show_log
end
