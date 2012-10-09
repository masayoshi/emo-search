# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  token      :string(255)      not null
#  secret     :string(255)
#  image_url  :string(255)
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authentication < ActiveRecord::Base
  attr_accessible :image_url, :provider, :secret, :token, :uid, :user_id
  belongs_to :user
end
