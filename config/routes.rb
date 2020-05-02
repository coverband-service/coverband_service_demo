Rails.application.routes.draw do
  root 'home#index'
  resources :posts

  get '/haml', to: 'home#haml'

  # NOTE make sure to have a constrait around any real production app
  # the demo app below purposefully shares it source code, but you likely do not want to
  # constraints basic_constraint do
  #  mount Coverband::Reporters::Web, at: '/coverage'
  # end
  mount Coverband::Reporters::Web.new, at: '/coverage'
end
