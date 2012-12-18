Spree::Core::Engine.routes.prepend do

  root :to => 'home#index'

  resources :products

  match '/locale/set', :to => 'locale#set'

  resources :tax_categories

  resources :states, :only => :index
  resources :countries, :only => :index

  # non-restful checkout stuff
  put '/checkout/update/:state', :to => 'checkout#update', :as => :update_checkout
  get '/checkout/:state', :to => 'checkout#edit', :as => :checkout_state
  get '/checkout', :to => 'checkout#edit' , :as => :checkout

  populate_redirect = redirect do |params, request|
    request.flash[:error] = I18n.t(:populate_get_error)
    request.referer || '/cart'
  end

  get '/orders/populate', :via => :get, :to => populate_redirect

  resources :orders do
    post :populate, :on => :collection

    resources :line_items

    resources :shipments do
      member do
        get :shipping_method
      end
    end

  end
  get '/cart', :to => 'orders#edit', :as => :cart
  put '/cart', :to => 'orders#update', :as => :update_cart
  put '/cart/empty', :to => 'orders#empty', :as => :empty_cart

  resources :shipments do
    member do
      get :shipping_method
      put :shipping_method
    end
  end

  # route globbing for pretty nested taxon and product paths
  match '/t/*id', :to => 'taxons#show', :as => :nested_taxons

  match '/unauthorized', :to => 'home#unauthorized', :as => :unauthorized
  match '/content/cvv', :to => 'content#cvv', :as => :cvv
  match '/content/*path', :to => 'content#show', :via => :get, :as => :content
end