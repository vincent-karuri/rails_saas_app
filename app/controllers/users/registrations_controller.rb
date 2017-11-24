class Users::RegistrationsController < Devise::RegistrationsController
    before_action :select_plan, only: :new
    
    # Extend default devise gem to take care of pro user and free user
    # subscription by subscribing pro users to Stripe
    def create
        super do |resource|
            # check for plan type and if pro, save the token from Stripe
            # as you save the new user. Else, just save the user in the 
            # normal way without adding a user token.
            if params[:plan]
               resource.plan_id = params[:plan] 
               if resource.plan_id == 2
                   resource.save_with_subscription
               else
                   resource.save
               end
            end
        end
    end
    
    private
        def select_plan
            unless(params[:plan] == '1' ||params[:plan] == '2')
                 flash[:notice] = "Please select a membership plan to sign up."
                 redirect_to root_url
            end
        end
end