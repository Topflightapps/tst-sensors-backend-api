Rails.application.routes.draw do

  get '/samples/:sensor_id', to: 'samples#index'
  post '/samples', to: 'samples#create'
end
