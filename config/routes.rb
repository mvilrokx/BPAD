BPAD::Application.routes.draw do
  resources :lookups
  resources :tags
  resources :work_assignments
  resources :logical_entity_attributes
  resources :interfaces
  resources :logical_entities
  resources :issues
  
  match '/plannings/calc' => 'plannings#calc'
  
  resources :plannings 
  
  resources :build_features

  resources :lbas do
    collection do
      get 'lba_children'
    end
  end

  resources :iterations
  resources :watchings
  resources :bam_to_fam_features
  resources :assignments
  resources :roles
  resources :reports
  resources :manage_priorities do
		collection do
		  get 'prioritize_paths'
    end
  end

  match  'signup' => 'users#new', :as => :signup
  match  'logout' => 'sessions#destroy', :as => :logout
  match  'login' => 'sessions#new', :as => :login

  resources :sessions
  resources :users

#  resources :bam_to_fam_maps



   resources :features do
     resource :watchings do
       member do
         get 'change_owner'
       end
     end
     resources :issues
     resources :fam_to_tam_maps do
       collection do
         get 'lba_children'
       end
     end
   end

#  resources :features, :has_many => [:watchings]

  resources :lbos
  resources :functional_work_units do
    collection do
      get 'features'
    end
  end
  resources :business_areas do
    collection do
      get 'lba_children'
    end
  end
#  resources :business_processes, :has_many => [:business_process_elements, :paths, :watchings]
  resources :business_processes do
    resources :business_process_elements, :issues
    resources :paths do
      member do
        get 'copy'
        put 'duplicate'
        get 'send_to_agilefant'
        get 'inform_functional_approvers'
      end
    end
    resources :watchings
  end

  resources :business_process_elements do
    resources :flows
  end

  resources :paths do
    resources :steps
    resources :watchings
    resources :issues
  end
#  resources :step, :has_one => :bam_to_fam_map
#  resources :step, :has_many => :bam_to_fam_features
  resources :bam_to_fam_maps do
    resources :approvals
  end

  resources :step do
    resource :bam_to_fam_map do
      collection do
        get 'lba_children'
      end
    end
#       step.resources :has_one => :bam_to_fam_map, :collection => { :lba_children => :get}
    resources :bam_to_fam_features
  end

  resources :fam_to_tam_maps

  root :to => "business_processes#index"
  match ':controller(/:action(/:id))'
  #map.connect ':controller/:action/:id.:format'

end

