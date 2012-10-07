class Authentication < ActiveRecord::Base
  attr_accessible :image_url, :provider, :secret, :token, :uid, :user_id
  belongs_to :user
end
