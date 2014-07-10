Rails.application.routes.draw do
  
  resources :iams, except: [:edit, :update]

  resources :policies
  resources :media

  resources :buckets, except: [:delete, :edit, :update] do
    resources :items, except: [:delete, :edit, :update] do
    end
    member do 
      
      #get 'new_item/:bucket',            to: 'items#new_item'
    end
  end

  resources :users

  resources :dynamotables, except: [:delete, :edit, :update]

  resources :emails, except: [:delete, :edit, :update]

  #resources :iams, except: [:delete, :edit, :update]

  get 'enable_versioning/:bucket',              to: 'buckets#enable_versioning'
  get 'delete_item/:bucket/:item',              to: 'items#delete_item'
  get 'show_item/:bucket/:item',                to: 'items#show_item'
  get 'change_storage_class/:bucket/:item/:storage_class_standard',     to: 'items#change_storage_class'
  get 'test_item_versions/:bucket',             to: 'items#test_item_versions'
  get 'delete_bucket/:name',                    to: 'buckets#delete_bucket'
  get 'delete_odd_versions/:bucket/:item',      to: 'items#delete_odd_versions'
  
  get 'verify_email/:email',                    to: 'emails#verify_email'  
  post 'update_email',                          to: 'emails#update_email' 
  get 'send_email/:email',                      to: 'emails#send_email' 
  post 'attempt_email/',                        to: 'emails#attempt_email' 
  get 'delete_table/:name',                     to: 'dynamotables#delete_table'
  get 'show_item/:name',                        to: 'dynamotables#show_item'
  get 'update_provisioned_throughput/:name',    to: 'dynamotables#update_provisioned_throughput'
  get 'new_item/:name',                        to: 'dynamotables#new_item'
  get 'update_item/:name',                     to: 'dynamotables#update_item'
  get 'delete_item/:name',                     to: 'dynamotables#delete_item'
  get 'batch_item/:name',                      to: 'dynamotables#batch_item'
  get 'query_item/:name',                      to: 'dynamotables#query_item'
  get 'scan_item/:name',                       to: 'dynamotables#scan_item'

  root "home#index"

  post 'postExample', :to => 'post_example#create'

  get 'show_group/:name',                      to: 'iams#show_group'
  get 'create_users/:name/:username',          to: 'iams#create_users'
  get 'delete_user/:name/:username',           to: 'iams#delete_user'
  get 'delete_users/',                         to: 'iams#delete_users'
  get 'add_users/:name',                       to: 'iams#add_users'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
