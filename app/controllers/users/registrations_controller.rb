class Users::RegistrationsController < Devise::RegistrationsController
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
end