Rails.application.routes.draw do
  # Routes for the Like resource:

  # CREATE
  post("/insert_like", { :controller => "likes", :action => "create" })
          
  # READ
  get("/likes", { :controller => "likes", :action => "index" })
  
  get("/likes/:path_id", { :controller => "likes", :action => "show" })
  
  # UPDATE
  
  post("/modify_like/:path_id", { :controller => "likes", :action => "update" })
  
  # DELETE
  get("/delete_like/:path_id", { :controller => "likes", :action => "destroy" })

  #------------------------------

  # Routes for the Follow request resource:
  # READ
  get("/follow_requests", { :controller => "follow_requests", :action => "index" })
  
  get("/follow_requests/:path_id", { :controller => "follow_requests", :action => "show" })

  # CREATE
  post("/insert_follow_request", { :controller => "follow_requests", :action => "create" })
  
  # UPDATE
  
  post("/modify_follow_request/:path_id", { :controller => "follow_requests", :action => "update" })
  
  # DELETE
  get("/delete_follow_request", { :controller => "follow_requests", :action => "destroy" })

  #------------------------------

  # Routes for the Comment resource:

  # CREATE
  post("/insert_comment", { :controller => "comments", :action => "create" })
          
  # READ
  get("/comments", { :controller => "comments", :action => "index" })
  
  get("/comments/:path_id", { :controller => "comments", :action => "show" })
  
  # UPDATE
  
  post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })
  
  # DELETE
  get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })

  #------------------------------

  # Routes for the User resource:

  # CREATE
  get("/user_sign_up", { :controller => "users", :action => "signup_form"})
  post("/insert_user", { :controller => "users", :action => "create" })
  
  # SIGN IN FORM
  get("/user_sign_in", { :controller => "users", :action => "sign_in_form" })
  
  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "users", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/user_sign_out", { :controller => "users", :action => "destroy_cookies" })

  # READ
  get("/users", { :controller => "users", :action => "index" })
  get("/", { :controller => "users", :action => "index" })
  
  get("/users/:the_username", { :controller => "users", :action => "show" })
  
  # UPDATE
  get("/edit_user_profile", { :controller => "users", :action => "modify"})
  post("/modify_user", { :controller => "users", :action => "update" })
  
  # DELETE
  get("/delete_user/:the_username", { :controller => "users", :action => "destroy" })


  #------------------------------

  # Routes for the Photo resource:

  # CREATE
  post("/insert_photo", { :controller => "photos", :action => "create" })
          
  # READ
  get("/photos", { :controller => "photos", :action => "index" })
  
  get("/photos/:path_id", { :controller => "photos", :action => "show" })
  
  # FEED
  get("/users/believe_in_yourself/feed", { :controller => "photos", :action => "feed"})

  # UPDATE
  
  post("/modify_photo/:path_id", { :controller => "photos", :action => "update" })
  
  # DELETE
  get("/delete_photo/:path_id", { :controller => "photos", :action => "destroy" })

  #------------------------------

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
