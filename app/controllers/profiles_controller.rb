class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :only_current_user
    
    # GET to /users/:user_id/profile/new
    def new
        # render blank profile details form
        @profile = Profile.new
    end
    
    # POST /users/:user_id/profile
    def create
        # Ensure that we have the user who is filling out form
        @user = User.find( params[:user_id] )
        # Create profile linked to this specific user
        @profile = @user.build_profile( profile_params )
        if @profile.save
            flash[:success] = "Profile updated!"
            redirect_to user_path( params[:user_id] )
        else
            render action: :new
        end
    end
    
    # GET to /users/:user_id/profile/edit
    def edit
        @user = User.find( params[:user_id] )
        @profile = @user.profile
    end
    
    # PUT to /users/:user_id/profile
    def update
        # retrieve user from db
        @user = User.find( params[:user_id] )
        # retrieve user profile
        @profile = @user.profile
        # mass assign edited profile attributes and save
        if @profile.update_attributes(profile_params)
            flash[:success] = "Profile updated!"
            # redirect user to their profile page
            redirect_to user_path(id: params[:user_id] )
        else
            render action: :edit
        end
    end
    
    private
        def profile_params
            params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
        end
        
        def only_current_user
            @user = User.find( params[:user_id] )
            redirect_to root_path unless @user == current_user
        end
end