ActionController::Routing::Routes.draw do |map|
  map.resources :data_object_instances

  map.resources :logical_entity_attributes

  map.resources :interfaces

  map.resources :logical_entities


  map.resources :issues

  map.resources :build_features

  map.resources :lbas, :collection => { :lba_children => :get}

  map.resources :iterations
  map.resources :watchings
  map.resources :bam_to_fam_features
  map.resources :assignments
  map.resources :roles


  map.resources :reports
  map.resources :manage_priorities,
		:collection => {:prioritize_paths => :get}

  map.signup 'signup', :controller => 'users', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.resources :sessions
  map.resources :users

#  map.resources :bam_to_fam_maps



   map.resources :features do |feature|
     feature.resource :watchings, :member => { :change_owner => :get}
     feature.resources :issues
     feature.resources :fam_to_tam_maps, :collection => { :lba_children => :get}
   end

#  map.resources :features, :has_many => [:watchings]



  map.resources :lbos
  map.resources :functional_work_units, :collection => {:features => :get}
  map.resources :business_areas,
                :collection => {:lba_children => :get}
#  map.resources :business_processes, :has_many => [:business_process_elements, :paths, :watchings]
  map.resources :business_processes do |business_process|
    business_process.resources :business_process_elements
    business_process.resources :paths,
                               :member => {:duplicate => :get,
                                           :send_to_agilefant => :get,
                                           :inform_functional_approvers => :get}
    business_process.resources :watchings
  end

  map.resources :business_process_elements, :has_many => :flows
  map.resources :paths, :has_many => [:steps, :watchings]
#  map.resources :step, :has_one => :bam_to_fam_map
#  map.resources :step, :has_many => :bam_to_fam_features
  map.resources :bam_to_fam_maps, :has_many => :approvals


   map.resources :step do |step|
     step.resource :bam_to_fam_map, :collection => { :lba_children => :get}
#       step.resources :has_one => :bam_to_fam_map, :collection => { :lba_children => :get}
     step.resources :bam_to_fam_features
   end

  map.resources :fam_to_tam_maps


#  map.resources :business_process_elements
#  map.resources :flows
#  map.resources :paths
#  map.resources :steps
#  map.resources :approvals

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => "business_processes"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

