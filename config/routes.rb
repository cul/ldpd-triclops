# frozen_string_literal: true

require 'resque/server'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'pages#home'

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present?
  end

  constraints resque_web_constraint do
    mount Resque::Server.new, at: '/resque'
  end

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: 'new_user_session'
    get 'sign_out', to: 'users/sessions#destroy', as: 'destroy_user_session'
    if Rails.env.development?
      get 'sign_in_developer', to: 'users/sessions#developer_new', as: 'developer_new_user_session'
    end
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :resources, only: [:show, :destroy]
      # Rather than using the built-in "update" controller action naming convention, we'll point
      # put/patch to a "create_or_replace" controller action to clarify what these routes do.
      [:put, :patch].each do |method|
        send(method, 'resources/:id' => 'resources#create_or_replace', as: nil)
      end
    end
  end

  namespace :iiif do
    scope ':version', version: /2/, defaults: { version: 2 } do
      get '/test_viewer', to: redirect('/iiif/2/test_viewer/sample'), as: 'test_viewer_default'
      get '/test_viewer/:identifier', to: 'images#test_viewer', as: 'test_viewer'
      get '/:identifier/:region/:size/:rotation/:quality', to: 'images#raster', as: 'raster'
      get '/:identifier/info.json', to: 'images#info', as: 'info'
    end
  end
end
