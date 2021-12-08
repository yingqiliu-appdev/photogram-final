class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index.html.erb" })
  end

  def show
    the_username = params.fetch("the_username")

    matching_users = User.where({ :username => the_username })

    @the_user = matching_users.at(0)

    @list_of_photos = Photo.where({ :owner_id => @the_user.id})

    render({ :template => "users/show.html.erb" })
  end

  def sign_in_form
    render({ :template => "users/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end


  def create
    the_user = User.new
    the_user.email = params.fetch("query_email")
    the_user.password = params.fetch("query_password")
    the_user.password_confirmation = params.fetch("query_password_confirmation")
    the_user.username = params.fetch("query_username")
    the_user.private = params.fetch("query_private", false)

    the_user.save

    if the_user.valid?

      session[:user_id] = the_user.id
      redirect_to("/users", { :notice => "User created successfully." })
    
    else
      redirect_to("/user_sign_up", { :alert => "User failed to create successfully." })
    
    end
  end

  def modify

    render({ :template => "users/edit_profile.html.erb"})

  end


  def update
    @current_user.comments_count = params.fetch("query_comments_count")
    @current_user.email = params.fetch("query_email")
    @current_user.likes_count = params.fetch("query_likes_count")
    @current_user.password = params.fetch("query_password")
    @current_user.password_confirmation = params.fetch("query_password_confirmation")
    @current_user.private = params.fetch("query_private", false)
    @current_user.username = params.fetch("query_username")

    if @current_user.valid?
      @current_user.save
      redirect_to("/", { :notice => "User updated successfully."} )
    else
      redirect_to("/edit_user_profile", { :alert => "User failed to update successfully." })
    end
  end


  def destroy
    the_username = params.fetch("the_username")
    the_user = User.where({ :username => the_username }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end


  def signup_form
    render({ :template => "users/user_signup.html.erb"})
  end



end
