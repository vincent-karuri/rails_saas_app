class ContactsController < ApplicationController
    before_action :authenticate_user!
    # GET request to /contact-us
    def new
        @contact = Contact.new
    end
    
    # POST request /contacts
    def create
        # mass assignment of form fields
        @contact = Contact.new(contact_params)
        
        # save Contact obj to db
        if @contact.save
            # field params
            name = params[:contact][:name]
            email = params[:contact][:email]
            body = params[:contact][:comments]
            
            # plug variables into contact mailer
            ContactMailer.contact_email(name, email, body).deliver
            
            # flash success message
            flash[:success] = "Message sent."
            redirect_to new_contact_path
        else
            # flash fail message with errors
            flash[:danger] = @contact.errors.full_messages.join(',')
            redirect_to new_contact_path
        end
    end
    
    private
        # collect data from form
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end
end 