Rails.application.routes.draw do
  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # provide the routes for the API here
      get 'investigations', to: 'investigations#index', as: :investigations
      get 'investigations/:id', to: 'investigations#detail', as: :investigations_detail
      post 'investigations/:id/notes', to: 'investigations#new_note', as: :investigations_note
      post 'investigations/:id/add_assignment', to: 'investigations#add_assignment', as: :add_assignment
      put 'end_assignment/:id', to: 'investigations#end_assignment', as: :end_assignment
      put 'drop_suspect/:id', to: 'investigations#drop_suspect', as: :drop_suspect
      get 'crimes', to: 'investigations#crimes', as: :all_crimes
      get 'officers', to: 'investigations#officer_search', as: :search_officers
      get 'criminals', to: 'investigations#criminals_search', as: :search_criminals
      post 'investigations/:id/suspects', to: 'investigations#new_suspect', as: :new_investigation_suspect
      post 'investigations/:id/crime_investigations', to: 'investigations#new_crime_investigation', as: :new_crime_investigation
      put 'investigations/:id', to: 'investigations#update', as: :update_investigation_detail
      delete 'investigations/:id/crimes/:crime_id', to: 'investigations#delete_crime_investigation', as: :delete_investigation_crime

      # Routes for earlier API; disabled for React useage (some overlap)
      # get 'units', to: 'units#index', as: :units
      # get 'criminals/enhanced', to: 'criminals#enhanced', as: :enhanced_criminals
      # get 'officers/:id', to: 'officers#show', as: :officer
      # get 'investigations/:id', to: 'investigations#show', as: :investigation
    
    end
  end

  # Routes for regular HTML views go here...
    # Semi-static page routes
    get 'home', to: 'home#index', as: :home
    get 'home/about', to: 'home#about', as: :about
    get 'home/contact', to: 'home#contact', as: :contact
    get 'home/privacy', to: 'home#privacy', as: :privacy

    # Authentication routes
    resources :sessions
    resources :officers
    get 'login', to: 'sessions#new', as: :login
    get 'logout', to: 'sessions#destroy', as: :logout
    root 'home#index'

    # Resource routes (maps HTTP verbs to controller actions automatically):
    resources :units
    resources :crimes
    resources :criminals
    resources :investigations
  
  
    # Routes for assignments

    

    # Routes for crime_investigations

    

    # Routes for investigation_notes

    

    # Other custom routes

    

    # You can have the root of your site routed with 'root'

    
end
