Prestissimo::Application.routes.draw do

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
      member do
	  get 'search'
      end
  end


  scope "(/:reportable_type/:reportable_id/:user_id)" do
	  resources :reports, only: [:new, :create, :update, :edit, :index] do
	  end
  end

  # Generates REST-style URI for comments, sessions
  scope "(/:commentable_type/:commentable_id)" do
    resources :comments do
      member do
	get 'reply_form'
	post 'reply'
	put 'hide_remove'
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
      get 'change'
      put 'update_all'
      get 'edit_motd'
      put 'set_motd'
    end
  end

  # Generates REST-style URI for carts
  resources :carts, only: [:create, :update, :destroy, :show] do
    member do
      scope "(/:semcrn)" do
	put 'add'
	put 'remove'
      end
      get 'mail_to'
      get 'search'
    end
  end

  resources :sessions, only: [:new, :create, :destroy] do
    collection do
     get 'hide_motd'
    end
  end

  resources :departments do
    collection do
      get 'search'
    end
  end
  resources :hubcourses, :path => "classes" do
    collection do
      get 'search'
    end
  end
  resources :departments do
    collection do
      get 'search'
    end
  end

  # Home page
  root to: 'courses#index'

  # route for search
  match '/courses/search', to: 'courses#search', as: :course_search

  # routes for user search
  match '/users/search', to: 'users#search', as: :user_search
  match '/users', to: 'users#index', as: :users


  # routes for static pages
  match '/about', to: 'static_pages#about'
  match '/help', to: 'static_pages#help'
  match '/guidelines', to: 'static_pages#guidelines'
  match '/help/basics', to: 'static_pages#basics'
  match '/help/features', to: 'static_pages#features'
  match '/help/questions', to: 'static_pages#questions'
  match '/help/advanced', to: 'static_pages#advanced'
  match '/secret', to: 'static_pages#secret'
  match '/qmailer', to: 'static_pages#questions_mailer'
  match '/help/accounts', to: 'static_pages#accounts'
  match '/help/cart', to: 'static_pages#cart'
  match '/help/comments', to: 'static_pages#comments'
  match '/help/hubpages', to: 'static_pages#hubpages'
  match '/help/phone', to: 'static_pages#phone'
  match '/help/search', to: 'static_pages#search'


  # other user and sessions routes
  match '/signup', to: 'users#new'
  match '/signin', to: 'users#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/create', to: 'users#create', as: :create_user
  match '/users/:id', to: 'users#show', as: :user
  match '/:id/settings', to: 'users#edit', as: :settings
  match '/update/:id', to: 'users#update', as: :update
  match '/delete/:id', to: 'users#destroy', as: :delete_user
  match '/users/confirm/delete/:id', to: 'users#confirm_destroy', as: :confirm_destroy
  match '/users/self_delete/:id', to: 'users#self_destroy', as: :self_destroy

  # handle routes
  match '/commenters/update/:id', to: 'handles#update', as: :update_handle
  match '/commenters', to: 'handles#index', as: :handles
  match '/commenters/search', to: 'handles#search', as: :handle_search
  match '/commenters/:username', to: 'handles#show', as: :show_handle
  match '/commenters/mute/:id', to: 'handles#mute', as: :mute_handle
  match '/commenters/reveal/:id', to: 'handles#reveal', as: :reveal_user

  # user activation route
  match '/:nonce/activate', to: 'users#activate'

  # routes related to forgot password process
  match '/forgot_pass', to: 'users#forgot_pass_page'
  match '/send_forgot_mail', to: 'users#send_forgot_mail'
  match '/:nonce/reset_pass', to: 'users#edit_pass'
  match '/:nonce/save_reset_pass', to: 'users#reset_pass', as: :reset_password

  #routes related to showing/hiding the search help box
  match '/hide_search', to: 'sessions#hide_search'
  match '/click_hide_search', to: 'sessions#click_hide_search'

  #routes related to toggling html/mobile layout
  match '/mobile_format', to: 'sessions#mobile_format'
  match '/click_mobile_format', to: 'sessions#click_mobile_format'

  # administrative route
  match '/admin', to: 'admins#admin', as: :admin_page

  # routes for professor page creation
  match '/professors/populate', to: 'professors#populate', as: :populate_professors
  match '/professors/empty', to: 'professors#empty', as: :empty_professors

  # more professor routes
  match '/professors/search', to: 'professors#search', as: :professor_search
  match '/professors/:id/edit', to: 'professors#edit', as: :edit_professor
  match '/professors/:id/toggle_active', to: 'professors#toggle_active', as: :toggle_active_professor
  match '/professors/:id/show', to: 'professors#show', as: :show_professor
  match '/professors/:id/update', to: 'professors#update', as: :update_professor


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
