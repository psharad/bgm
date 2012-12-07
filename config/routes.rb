ActionController::Routing::Routes.draw do |map|
  map.resources :tag_lines

  map.resources :local_offers, :collection => {:load => :get, :send_local_offer => :get},
                               :member => {:main => :get}

  map.resources :local_offers_tracks
  
  map.resources :dashboards

  map.resources :images

  map.resources :posts, :member => {:main => :get, 
                                    :save_image => :put},
                        :collection => {:load => :get} 
                        
  map.resources :user_sessions

  map.resources :admins, :as => 'admin',
    :collection => {
      :blogger => :get, 
      :beta_key => :get, 
      :groups => :get, 
      :deactivate => :get, 
      :interests => :get, 
      :tag_lines => :get, 
      :tag_lines_update => :put,
      :cities => :get}

  map.resources :admin_sessions
  
  map.resources :preferences

  map.resources :members, :collection => {:edit_search_by_email => :get, :search_by_email => :get, :email_value => :get, :edit_check => :get, :add => :get, :save_added => :post}
  map.resources :user_sessions
  
  map.choose_method "/users/choose-method", :controller => :users, :action => :choose_method
  map.choose_method_facebook "/users/choose-method-facebook", :controller => :users, :action => :choose_method_facebook
  map.new_leader_profile "/users/new-leader-profile", :controller => :users, :action => :new_leader_profile
  map.new_leader_profile_m "/users/new-leader-profile-m", :controller => :users, :action => :new_leader_profile_m
  map.add_member "/users/add-member", :controller => :users, :action => :add_member 
  map.group_preferences "/users/group-preferences", :controller => :users, :action => :group_preferences
  map.group_upload_photo "/users/group-upload-photo", :controller => :users, :action => :group_upload_photo
  map.grab_from_facebook "/users/grab-from-facebook", :controller => :users, :action => :grab_from_facebook
  map.add_member_fb "/users/add-member-fb", :controller => :users, :action => :add_member_fb
  map.autocomplete_friends "/autocomplete_friends", :controller => :users, :action => :autocomplete_friends

  map.resources :users, :collection => {:reset_password_request => :get,
                                        :reset_password => :get, 
                                        :congrats => :get,
                                        :email_retrieve => :get,
                                        :suggest => :get,
                                        :send_suggest => :post,
                                        :create_leader => :post,
                                        :create_member => :get,
                                        :create_preferences => :post,
                                        :save_group_photo => :post,
                                        :populate_member => :post,
                                        :finish_registration => :get,
                                        :admin_user_access => :get}, 
                        :has_many => :groups
    
  map.resources :occupations
  map.resources :universities
  map.resources :educations
  map.resources :languages
  map.resources :ethnicities
  map.resources :builts
  map.resources :heights
  map.resources :groups, :has_many => { :members => :get,
                                        :preferences => :get}, 
                         :member => {:email => :get,
                                     :upload_photo => :get,
                                     :choose_album => :get,
                                     :album => :get,
                                     :save_fb_image => :get,
                                     :save_uploaded_photo => :put,
                                     :save_preference => :get,
                                     :remove => :get,
                                     :no_member => :get,
                                     :edit_photo => :get,
                                     :save_edit_photo => :put,
                                     :deactivate => :get},
                         :collection => {:mail_sent => :get,
                                         :check_group => :get,
                                         :report => :get,
                                         :delete_member => :put,
                                         :login_again => :get}
  map.resources :homes, :collection => {:soon => :get,
                                        :about => :get,
                                        :add_icon => :get,
                                        :terms => :get,
                                        :terms_of_use => :get,
                                        :privacy => :get,
                                        :resources => :get,
                                        :local_offers => :get,
                                        :more_tweets => :get
                                        },
                        :member => {:local_offer => :get}

  # map.resources :beta_pages, :as => 'beta', :collection => [:more_tweets]
  map.resources :search, :only => [:index, :new]
  map.resources :facebook_sessions, :only => [:new, :create, :destroy], :collection => {:get_fb_info => :get}
  map.resources :twitter_sessions, :only => [:new, :destroy], :collection => {:final => :get, :post => :post, :catch => :get}
  
  # map.check_beta_key 'check_beta_key', :controller => 'beta_pages', :action => 'check_beta_key'
  # map.beta_key_request 'beta_key_request', :controller => 'beta_pages', :action => 'beta_key_request'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => :application, :action => :homepage

  map.home "home", :controller => :homes, :action => :show
  map.main "main", :controller => :homes, :action => :index
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  
  # map.dashboard "admin", :controller => "admins", :action => "index"
  map.admin_login "admin_login", :controller => "admin_sessions", :action => "new"
  map.admin_logout "admin_logout", :controller => "admin_sessions", :action => "destroy"
  
end
#== Route Map
# Generated on 06 Jul 2011 05:49
#
#                  preferences GET    /preferences(.:format)                                              {:controller=>"preferences", :action=>"index"}
#                              POST   /preferences(.:format)                                              {:controller=>"preferences", :action=>"create"}
#               new_preference GET    /preferences/new(.:format)                                          {:controller=>"preferences", :action=>"new"}
#              edit_preference GET    /preferences/:id/edit(.:format)                                     {:controller=>"preferences", :action=>"edit"}
#                   preference GET    /preferences/:id(.:format)                                          {:controller=>"preferences", :action=>"show"}
#                              PUT    /preferences/:id(.:format)                                          {:controller=>"preferences", :action=>"update"}
#                              DELETE /preferences/:id(.:format)                                          {:controller=>"preferences", :action=>"destroy"}
#           save_added_members POST   /members/save_added(.:format)                                       {:controller=>"members", :action=>"save_added"}
#      search_by_email_members GET    /members/search_by_email(.:format)                                  {:controller=>"members", :action=>"search_by_email"}
#          email_value_members GET    /members/email_value(.:format)                                      {:controller=>"members", :action=>"email_value"}
#           edit_check_members GET    /members/edit_check(.:format)                                       {:controller=>"members", :action=>"edit_check"}
#                  add_members GET    /members/add(.:format)                                              {:controller=>"members", :action=>"add"}
# edit_search_by_email_members GET    /members/edit_search_by_email(.:format)                             {:controller=>"members", :action=>"edit_search_by_email"}
#                      members GET    /members(.:format)                                                  {:controller=>"members", :action=>"index"}
#                              POST   /members(.:format)                                                  {:controller=>"members", :action=>"create"}
#                   new_member GET    /members/new(.:format)                                              {:controller=>"members", :action=>"new"}
#                  edit_member GET    /members/:id/edit(.:format)                                         {:controller=>"members", :action=>"edit"}
#                       member GET    /members/:id(.:format)                                              {:controller=>"members", :action=>"show"}
#                              PUT    /members/:id(.:format)                                              {:controller=>"members", :action=>"update"}
#                              DELETE /members/:id(.:format)                                              {:controller=>"members", :action=>"destroy"}
#                user_sessions GET    /user_sessions(.:format)                                            {:controller=>"user_sessions", :action=>"index"}
#                              POST   /user_sessions(.:format)                                            {:controller=>"user_sessions", :action=>"create"}
#             new_user_session GET    /user_sessions/new(.:format)                                        {:controller=>"user_sessions", :action=>"new"}
#            edit_user_session GET    /user_sessions/:id/edit(.:format)                                   {:controller=>"user_sessions", :action=>"edit"}
#                 user_session GET    /user_sessions/:id(.:format)                                        {:controller=>"user_sessions", :action=>"show"}
#                              PUT    /user_sessions/:id(.:format)                                        {:controller=>"user_sessions", :action=>"update"}
#                              DELETE /user_sessions/:id(.:format)                                        {:controller=>"user_sessions", :action=>"destroy"}
#                  user_groups GET    /users/:user_id/groups(.:format)                                    {:controller=>"groups", :action=>"index"}
#                              POST   /users/:user_id/groups(.:format)                                    {:controller=>"groups", :action=>"create"}
#               new_user_group GET    /users/:user_id/groups/new(.:format)                                {:controller=>"groups", :action=>"new"}
#              edit_user_group GET    /users/:user_id/groups/:id/edit(.:format)                           {:controller=>"groups", :action=>"edit"}
#                   user_group GET    /users/:user_id/groups/:id(.:format)                                {:controller=>"groups", :action=>"show"}
#                              PUT    /users/:user_id/groups/:id(.:format)                                {:controller=>"groups", :action=>"update"}
#                              DELETE /users/:user_id/groups/:id(.:format)                                {:controller=>"groups", :action=>"destroy"}
#           send_suggest_users POST   /users/send_suggest(.:format)                                       {:controller=>"users", :action=>"send_suggest"}
# reset_password_request_users GET    /users/reset_password_request(.:format)                             {:controller=>"users", :action=>"reset_password_request"}
#               congrats_users GET    /users/congrats(.:format)                                           {:controller=>"users", :action=>"congrats"}
#         reset_password_users GET    /users/reset_password(.:format)                                     {:controller=>"users", :action=>"reset_password"}
#         email_retrieve_users GET    /users/email_retrieve(.:format)                                     {:controller=>"users", :action=>"email_retrieve"}
#                suggest_users GET    /users/suggest(.:format)                                            {:controller=>"users", :action=>"suggest"}
#                        users GET    /users(.:format)                                                    {:controller=>"users", :action=>"index"}
#                              POST   /users(.:format)                                                    {:controller=>"users", :action=>"create"}
#                     new_user GET    /users/new(.:format)                                                {:controller=>"users", :action=>"new"}
#                    edit_user GET    /users/:id/edit(.:format)                                           {:controller=>"users", :action=>"edit"}
#                         user GET    /users/:id(.:format)                                                {:controller=>"users", :action=>"show"}
#                              PUT    /users/:id(.:format)                                                {:controller=>"users", :action=>"update"}
#                              DELETE /users/:id(.:format)                                                {:controller=>"users", :action=>"destroy"}
#                  occupations GET    /occupations(.:format)                                              {:controller=>"occupations", :action=>"index"}
#                              POST   /occupations(.:format)                                              {:controller=>"occupations", :action=>"create"}
#               new_occupation GET    /occupations/new(.:format)                                          {:controller=>"occupations", :action=>"new"}
#              edit_occupation GET    /occupations/:id/edit(.:format)                                     {:controller=>"occupations", :action=>"edit"}
#                   occupation GET    /occupations/:id(.:format)                                          {:controller=>"occupations", :action=>"show"}
#                              PUT    /occupations/:id(.:format)                                          {:controller=>"occupations", :action=>"update"}
#                              DELETE /occupations/:id(.:format)                                          {:controller=>"occupations", :action=>"destroy"}
#                 universities GET    /universities(.:format)                                             {:controller=>"universities", :action=>"index"}
#                              POST   /universities(.:format)                                             {:controller=>"universities", :action=>"create"}
#               new_university GET    /universities/new(.:format)                                         {:controller=>"universities", :action=>"new"}
#              edit_university GET    /universities/:id/edit(.:format)                                    {:controller=>"universities", :action=>"edit"}
#                   university GET    /universities/:id(.:format)                                         {:controller=>"universities", :action=>"show"}
#                              PUT    /universities/:id(.:format)                                         {:controller=>"universities", :action=>"update"}
#                              DELETE /universities/:id(.:format)                                         {:controller=>"universities", :action=>"destroy"}
#                   educations GET    /educations(.:format)                                               {:controller=>"educations", :action=>"index"}
#                              POST   /educations(.:format)                                               {:controller=>"educations", :action=>"create"}
#                new_education GET    /educations/new(.:format)                                           {:controller=>"educations", :action=>"new"}
#               edit_education GET    /educations/:id/edit(.:format)                                      {:controller=>"educations", :action=>"edit"}
#                    education GET    /educations/:id(.:format)                                           {:controller=>"educations", :action=>"show"}
#                              PUT    /educations/:id(.:format)                                           {:controller=>"educations", :action=>"update"}
#                              DELETE /educations/:id(.:format)                                           {:controller=>"educations", :action=>"destroy"}
#                    languages GET    /languages(.:format)                                                {:controller=>"languages", :action=>"index"}
#                              POST   /languages(.:format)                                                {:controller=>"languages", :action=>"create"}
#                 new_language GET    /languages/new(.:format)                                            {:controller=>"languages", :action=>"new"}
#                edit_language GET    /languages/:id/edit(.:format)                                       {:controller=>"languages", :action=>"edit"}
#                     language GET    /languages/:id(.:format)                                            {:controller=>"languages", :action=>"show"}
#                              PUT    /languages/:id(.:format)                                            {:controller=>"languages", :action=>"update"}
#                              DELETE /languages/:id(.:format)                                            {:controller=>"languages", :action=>"destroy"}
#                  ethnicities GET    /ethnicities(.:format)                                              {:controller=>"ethnicities", :action=>"index"}
#                              POST   /ethnicities(.:format)                                              {:controller=>"ethnicities", :action=>"create"}
#                new_ethnicity GET    /ethnicities/new(.:format)                                          {:controller=>"ethnicities", :action=>"new"}
#               edit_ethnicity GET    /ethnicities/:id/edit(.:format)                                     {:controller=>"ethnicities", :action=>"edit"}
#                    ethnicity GET    /ethnicities/:id(.:format)                                          {:controller=>"ethnicities", :action=>"show"}
#                              PUT    /ethnicities/:id(.:format)                                          {:controller=>"ethnicities", :action=>"update"}
#                              DELETE /ethnicities/:id(.:format)                                          {:controller=>"ethnicities", :action=>"destroy"}
#                       builts GET    /builts(.:format)                                                   {:controller=>"builts", :action=>"index"}
#                              POST   /builts(.:format)                                                   {:controller=>"builts", :action=>"create"}
#                    new_built GET    /builts/new(.:format)                                               {:controller=>"builts", :action=>"new"}
#                   edit_built GET    /builts/:id/edit(.:format)                                          {:controller=>"builts", :action=>"edit"}
#                        built GET    /builts/:id(.:format)                                               {:controller=>"builts", :action=>"show"}
#                              PUT    /builts/:id(.:format)                                               {:controller=>"builts", :action=>"update"}
#                              DELETE /builts/:id(.:format)                                               {:controller=>"builts", :action=>"destroy"}
#                      heights GET    /heights(.:format)                                                  {:controller=>"heights", :action=>"index"}
#                              POST   /heights(.:format)                                                  {:controller=>"heights", :action=>"create"}
#                   new_height GET    /heights/new(.:format)                                              {:controller=>"heights", :action=>"new"}
#                  edit_height GET    /heights/:id/edit(.:format)                                         {:controller=>"heights", :action=>"edit"}
#                       height GET    /heights/:id(.:format)                                              {:controller=>"heights", :action=>"show"}
#                              PUT    /heights/:id(.:format)                                              {:controller=>"heights", :action=>"update"}
#                              DELETE /heights/:id(.:format)                                              {:controller=>"heights", :action=>"destroy"}
#       group_member_get_index GET    /groups/:group_id/members/:member_id/get(.:format)                  {:controller=>"get", :action=>"index"}
#                              POST   /groups/:group_id/members/:member_id/get(.:format)                  {:controller=>"get", :action=>"create"}
#         new_group_member_get GET    /groups/:group_id/members/:member_id/get/new(.:format)              {:controller=>"get", :action=>"new"}
#        edit_group_member_get GET    /groups/:group_id/members/:member_id/get/:id/edit(.:format)         {:controller=>"get", :action=>"edit"}
#             group_member_get GET    /groups/:group_id/members/:member_id/get/:id(.:format)              {:controller=>"get", :action=>"show"}
#                              PUT    /groups/:group_id/members/:member_id/get/:id(.:format)              {:controller=>"get", :action=>"update"}
#                              DELETE /groups/:group_id/members/:member_id/get/:id(.:format)              {:controller=>"get", :action=>"destroy"}
#                group_members GET    /groups/:group_id/members(.:format)                                 {:controller=>"members", :action=>"index"}
#                              POST   /groups/:group_id/members(.:format)                                 {:controller=>"members", :action=>"create"}
#             new_group_member GET    /groups/:group_id/members/new(.:format)                             {:controller=>"members", :action=>"new"}
#            edit_group_member GET    /groups/:group_id/members/:id/edit(.:format)                        {:controller=>"members", :action=>"edit"}
#                 group_member GET    /groups/:group_id/members/:id(.:format)                             {:controller=>"members", :action=>"show"}
#                              PUT    /groups/:group_id/members/:id(.:format)                             {:controller=>"members", :action=>"update"}
#                              DELETE /groups/:group_id/members/:id(.:format)                             {:controller=>"members", :action=>"destroy"}
#   group_preference_get_index GET    /groups/:group_id/preferences/:preference_id/get(.:format)          {:controller=>"get", :action=>"index"}
#                              POST   /groups/:group_id/preferences/:preference_id/get(.:format)          {:controller=>"get", :action=>"create"}
#     new_group_preference_get GET    /groups/:group_id/preferences/:preference_id/get/new(.:format)      {:controller=>"get", :action=>"new"}
#    edit_group_preference_get GET    /groups/:group_id/preferences/:preference_id/get/:id/edit(.:format) {:controller=>"get", :action=>"edit"}
#         group_preference_get GET    /groups/:group_id/preferences/:preference_id/get/:id(.:format)      {:controller=>"get", :action=>"show"}
#                              PUT    /groups/:group_id/preferences/:preference_id/get/:id(.:format)      {:controller=>"get", :action=>"update"}
#                              DELETE /groups/:group_id/preferences/:preference_id/get/:id(.:format)      {:controller=>"get", :action=>"destroy"}
#            group_preferences GET    /groups/:group_id/preferences(.:format)                             {:controller=>"preferences", :action=>"index"}
#                              POST   /groups/:group_id/preferences(.:format)                             {:controller=>"preferences", :action=>"create"}
#         new_group_preference GET    /groups/:group_id/preferences/new(.:format)                         {:controller=>"preferences", :action=>"new"}
#        edit_group_preference GET    /groups/:group_id/preferences/:id/edit(.:format)                    {:controller=>"preferences", :action=>"edit"}
#             group_preference GET    /groups/:group_id/preferences/:id(.:format)                         {:controller=>"preferences", :action=>"show"}
#                              PUT    /groups/:group_id/preferences/:id(.:format)                         {:controller=>"preferences", :action=>"update"}
#                              DELETE /groups/:group_id/preferences/:id(.:format)                         {:controller=>"preferences", :action=>"destroy"}
#             mail_sent_groups GET    /groups/mail_sent(.:format)                                         {:controller=>"groups", :action=>"mail_sent"}
#           check_group_groups GET    /groups/check_group(.:format)                                       {:controller=>"groups", :action=>"check_group"}
#                report_groups GET    /groups/report(.:format)                                            {:controller=>"groups", :action=>"report"}
#           login_again_groups GET    /groups/login_again(.:format)                                       {:controller=>"groups", :action=>"login_again"}
#         delete_member_groups PUT    /groups/delete_member(.:format)                                     {:controller=>"groups", :action=>"delete_member"}
#                       groups GET    /groups(.:format)                                                   {:controller=>"groups", :action=>"index"}
#                              POST   /groups(.:format)                                                   {:controller=>"groups", :action=>"create"}
#                    new_group GET    /groups/new(.:format)                                               {:controller=>"groups", :action=>"new"}
#                   edit_group GET    /groups/:id/edit(.:format)                                          {:controller=>"groups", :action=>"edit"}
#                  email_group GET    /groups/:id/email(.:format)                                         {:controller=>"groups", :action=>"email"}
#                 remove_group GET    /groups/:id/remove(.:format)                                        {:controller=>"groups", :action=>"remove"}
#        save_preference_group GET    /groups/:id/save_preference(.:format)                               {:controller=>"groups", :action=>"save_preference"}
#           upload_photo_group GET    /groups/:id/upload_photo(.:format)                                  {:controller=>"groups", :action=>"upload_photo"}
#              no_member_group GET    /groups/:id/no_member(.:format)                                     {:controller=>"groups", :action=>"no_member"}
#           choose_album_group GET    /groups/:id/choose_album(.:format)                                  {:controller=>"groups", :action=>"choose_album"}
#             edit_photo_group GET    /groups/:id/edit_photo(.:format)                                    {:controller=>"groups", :action=>"edit_photo"}
#                  album_group GET    /groups/:id/album(.:format)                                         {:controller=>"groups", :action=>"album"}
#          save_fb_image_group GET    /groups/:id/save_fb_image(.:format)                                 {:controller=>"groups", :action=>"save_fb_image"}
#    save_uploaded_photo_group PUT    /groups/:id/save_uploaded_photo(.:format)                           {:controller=>"groups", :action=>"save_uploaded_photo"}
#        save_edit_photo_group PUT    /groups/:id/save_edit_photo(.:format)                               {:controller=>"groups", :action=>"save_edit_photo"}
#                        group GET    /groups/:id(.:format)                                               {:controller=>"groups", :action=>"show"}
#                              PUT    /groups/:id(.:format)                                               {:controller=>"groups", :action=>"update"}
#                              DELETE /groups/:id(.:format)                                               {:controller=>"groups", :action=>"destroy"}
#               add_icon_homes GET    /homes/add_icon(.:format)                                           {:controller=>"homes", :action=>"add_icon"}
#                  about_homes GET    /homes/about(.:format)                                              {:controller=>"homes", :action=>"about"}
#              resources_homes GET    /homes/resources(.:format)                                          {:controller=>"homes", :action=>"resources"}
#                  terms_homes GET    /homes/terms(.:format)                                              {:controller=>"homes", :action=>"terms"}
#                privacy_homes GET    /homes/privacy(.:format)                                            {:controller=>"homes", :action=>"privacy"}
#                   soon_homes GET    /homes/soon(.:format)                                               {:controller=>"homes", :action=>"soon"}
#                        homes GET    /homes(.:format)                                                    {:controller=>"homes", :action=>"index"}
#                              POST   /homes(.:format)                                                    {:controller=>"homes", :action=>"create"}
#                     new_home GET    /homes/new(.:format)                                                {:controller=>"homes", :action=>"new"}
#                    edit_home GET    /homes/:id/edit(.:format)                                           {:controller=>"homes", :action=>"edit"}
#                              GET    /homes/:id(.:format)                                                {:controller=>"homes", :action=>"show"}
#                              PUT    /homes/:id(.:format)                                                {:controller=>"homes", :action=>"update"}
#                              DELETE /homes/:id(.:format)                                                {:controller=>"homes", :action=>"destroy"}
#                   beta_pages GET    /beta(.:format)                                                     {:controller=>"beta_pages", :action=>"index"}
#                              POST   /beta(.:format)                                                     {:controller=>"beta_pages", :action=>"create"}
#                new_beta_page GET    /beta/new(.:format)                                                 {:controller=>"beta_pages", :action=>"new"}
#               edit_beta_page GET    /beta/:id/edit(.:format)                                            {:controller=>"beta_pages", :action=>"edit"}
#                    beta_page GET    /beta/:id(.:format)                                                 {:controller=>"beta_pages", :action=>"show"}
#                              PUT    /beta/:id(.:format)                                                 {:controller=>"beta_pages", :action=>"update"}
#                              DELETE /beta/:id(.:format)                                                 {:controller=>"beta_pages", :action=>"destroy"}
#                 search_index GET    /search(.:format)                                                   {:controller=>"search", :action=>"index"}
#                   new_search GET    /search/new(.:format)                                               {:controller=>"search", :action=>"new"}
#            facebook_sessions POST   /facebook_sessions(.:format)                                        {:controller=>"facebook_sessions", :action=>"create"}
#         new_facebook_session GET    /facebook_sessions/new(.:format)                                    {:controller=>"facebook_sessions", :action=>"new"}
#             facebook_session DELETE /facebook_sessions/:id(.:format)                                    {:controller=>"facebook_sessions", :action=>"destroy"}
#        post_twitter_sessions POST   /twitter_sessions/post(.:format)                                    {:controller=>"twitter_sessions", :action=>"post"}
#       catch_twitter_sessions GET    /twitter_sessions/catch(.:format)                                   {:controller=>"twitter_sessions", :action=>"catch"}
#       final_twitter_sessions GET    /twitter_sessions/final(.:format)                                   {:controller=>"twitter_sessions", :action=>"final"}
#          new_twitter_session GET    /twitter_sessions/new(.:format)                                     {:controller=>"twitter_sessions", :action=>"new"}
#              twitter_session DELETE /twitter_sessions/:id(.:format)                                     {:controller=>"twitter_sessions", :action=>"destroy"}
#               check_beta_key        /check_beta_key                                                     {:controller=>"beta_pages", :action=>"check_beta_key"}
#             beta_key_request        /beta_key_request                                                   {:controller=>"beta_pages", :action=>"beta_key_request"}
#                                     /:controller/:action/:id                                            
#                                     /:controller/:action/:id(.:format)                                  
#                         root        /                                                                   {:controller=>"application", :action=>"homepage"}
#                         home        /home                                                               {:controller=>"homes", :action=>"show"}
#                         main        /main                                                               {:controller=>"homes", :action=>"index"}
#                        login        /login                                                              {:controller=>"user_sessions", :action=>"new"}
#                       logout        /logout                                                             {:controller=>"user_sessions", :action=>"destroy"}
