class Contact < ActiveRecord::Base
    # validate contact
    validates :name, presence: true
    validates :email, presence: true
    validates :comments, presence: true
end