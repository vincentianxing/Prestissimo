Rails.application.routes.draw do
  #example of what 'resources :users' would create automatically
  #
  #HTTP	URI		action	    path			purpose
  #
  #GET	/users		index	    users_path			page to list all users
  #GET	/users/1        show	    user_path(user)		page to show user
  #GET	/users/new	new	    new_user_path		page to make a new user (signup)
  #POST	/users		create	    users_path			create a new user
  #GET	/users/1/edit	edit	    edit_user_path(user)	page to edit user with id 1
  #PUT	/users/1	update	    user_path(user)		update user
  #DELETE	/users/1	destroy	    user_path(user)		delete user

  # Generates REST-style URI for my_classes
  resources :my_classes do
    get "search"
  end

  scope "(/:reportable_type/:reportable_id/:user_id)" do
    resources :reports, only: [:new, :create, :update, :edit, :index] do
    end
  end

  # Generates REST-style URI for comments, sessions
  scope "(/:commentable_type/:commentable_id)" do
    resources :comments do
      member do
        get "reply_form"
        post "reply"
        put "hide_remove"
      end
    end
  end

  # Generates REST-style URI for votes
  scope "(/:handle_id/:comment_id)" do
    resources :votes
  end

  # Generates REST-style URI for settings
  resources :settings, only: [] do
    collection do
      get "change"
      put "update_all"
      get "edit_motd"
      put "set_motd"
    end
  end

  # Generates REST-style URI for carts
  resources :carts, only: [:create, :update, :destroy, :show] do
    member do
      scope "(/:semcrn)" do
        put "add"
        put "remove"
        put "clear"
      end
      get "mail_to"
      get "search"
    end
  end

  resources :sessions, only: [:new, :create, :destroy] do
    collection do
      get "hide_motd"
      get "hide_disclaimer"
    end
  end

  resources :departments do
    collection do
      get "search"
    end
  end
  resources :hubcourses, :path => "classes" do
    collection do
      get "search"
    end
  end

  # Home page
  root to: "courses#index"

  # route for search
  match "/courses/search", to: "courses#search", as: :course_search, via: [:get, :post]

  # routes for editing courses as a professor
  match "/courses/(:semcrn)/edit", to: "courses#edit", as: :course_edit, via: [:get, :post]
  match "/courses/:id/update", to: "courses#update", as: :update_course, via: [:get, :post]

  # routes for user search
  match "/users/search", to: "users#search", as: :user_search, via: [:get, :post]
  match "/users", to: "users#index", as: :users, via: [:get, :post]

  # routes for static pages
  get "/about", to: "static_pages#about"
  get "/reqs", to: "static_pages#reqs"
  get "/help", to: "static_pages#help"
  get "/guidelines", to: "static_pages#guidelines"
  get "/help/basics", to: "static_pages#basics"
  get "/help/features", to: "static_pages#features"
  get "/help/questions", to: "static_pages#questions"
  get "/help/advanced", to: "static_pages#basics" #There used to be a Basics and an Advanced search page, but these were combined
  get "/secret", to: "static_pages#secret"
  get "/qmailer", to: "static_pages#questions_mailer"
  get "/emailer", to: "static_pages#error_mailer"
  get "/help/accounts", to: "static_pages#accounts"
  get "/help/cart", to: "static_pages#cart"
  get "/help/comments", to: "static_pages#comments"
  get "/help/hubpages", to: "static_pages#hubpages"
  get "/help/professors", to: "static_pages#professors"
  get "/help/phone", to: "static_pages#phone"
  get "/help/search", to: "static_pages#search"
  get "/help/editcourse", to: "static_pages#editcourse"
  get "/help/error", to: "static_pages#nameerror", as: :nameerror
  get "/links", to: "static_pages#links"

  # other user and sessions routes
  match "/signin", to: "users#new", as: :signin, via: [:get, :post]
  match "/signout", to: "sessions#destroy", via: :delete
  match "/create", to: "users#create", as: :create_user, via: [:get, :post]
  match "/users/" + ":email".split("@")[0], to: "users#show", as: :user, via: [:get, :post]
  match "/users/" + ":email".split("@")[0] + "/settings", to: "users#edit", as: :settings, via: [:get, :post]
  match "/users/" + ":email".split("@")[0] + "/schedule", to: "users#schedule", as: :schedule, via: [:get, :post]
  match "/update/:id", to: "users#update", as: :update, via: [:get, :post]
  match "/delete/:id", to: "users#destroy", as: :delete_user, via: [:get, :post]
  match "/users/confirm/delete/" + ":email".split("@")[0], to: "users#confirm_destroy", as: :confirm_destroy, via: [:get, :post]
  match "/users/self_delete/:id", to: "users#self_destroy", as: :self_destroy, via: [:get, :post]

  # handle routes
  match "/commenters/update/:id", to: "handles#update", as: :update_handle, via: [:get, :post]
  match "/commenters", to: "handles#index", as: :handles, via: [:get, :post]
  match "/commenters/search", to: "handles#search", as: :handle_search, via: [:get, :post]
  match "/commenters/:username", to: "handles#show", as: :show_handle, via: [:get, :post]
  match "/commenters/mute/:id", to: "handles#mute", as: :mute_handle, via: [:get, :post]
  match "/commenters/reveal/:id", to: "handles#reveal", as: :reveal_user, via: [:get, :post]

  #routes related to showing/hiding the search help box
  match "/hide_search", to: "sessions#hide_search", via: [:get, :post]
  match "/click_hide_search", to: "sessions#click_hide_search", via: [:get, :post]

  #routes related to toggling html/mobile layout
  match "/mobile_format", to: "sessions#mobile_format", via: [:get, :post]
  match "/click_mobile_format", to: "sessions#click_mobile_format", via: [:get, :post]

  # administrative route
  match "/admin", to: "admins#admin", as: :admin_page, via: [:get, :post]
  match "/admin/expire_sessions", to: "admins#expire_sessions", as: :expire_sessions, via: [:get, :post]

  # route for professor page creation -- NOT USED, AND OUT OF DATE
  # match '/professors/populate', to: 'professors#populate', as: :populate_professors

  # more professor routes
  match "/professors/search", to: "professors#search", as: :professor_search, via: [:get, :post]
  match "/professors/(:fname)_(:lname)/edit", to: "professors#edit", as: :edit_professor, :fname => /.*/, via: [:get, :post]
  match "/professors/(:fname)_(:lname)/toggleactive", to: "professors#toggle_active", as: :toggle_active_professor, :fname => /.*/, via: [:get, :post]
  match "/professors/(:fname)_(:lname)", to: "professors#show", as: :show_professor, :fname => /.*/, via: [:get, :post]
  match "/professors/:id/update", to: "professors#update", as: :update_professor, via: [:get, :post]
  match "/professors/(:fname)_(:lname)/contentpreview", to: "professors#preview", as: :professor_content_preview, via: [:get, :post]
  match "/professors/(:fname)_(:lname)/courses", to: "professors#professor_courses", as: :professor_courses, via: [:get, :post]

  # syllabus routes
  match "/syllabus/new/:id", to: "syllabus#new", as: :new_syllabus, via: [:get, :post]
  match "/syllabus/create/:id", to: "syllabus#create", as: :create_syllabus, via: [:get, :post]
  match "/syllabus/:id", to: "syllabus#show", as: :syllabus, via: [:get, :post]

  # Routes for error pages
  get "/404", to: "errors#not_found", as: :error_404
  get "/422", to: "errors#server_error"
  get "/500", to: "errors#server_error"
  # Random route for clearing cookies,
  match "/clear_cookies", to: "errors#clear", as: :clear_cookies, via: [:get, :post]

  # Routes for charts
  get "charts/new_users", to: "charts#new_users"
  get "charts/site_visits", to: "charts#site_visits"
  get "charts/searches_dept", to: "charts#searches_dept"
  get "charts/searches_volume", to: "charts#searches_volume"
  get "charts/visitor_location", to: "charts#visitor_location"
  get "charts/referrals", to: "charts#referrals"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
