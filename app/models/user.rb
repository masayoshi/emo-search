# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  username               :string(255)
#  image_url              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :image_url

  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :authentications, dependent: :destroy

  def self.find_for_twitter_oauth(auth, current_user = nil)
    authentication = Authentication.find_by_provider_and_uid("twitter", auth.uid.to_s)
    dummy_email = "dummy-#{auth['uid']}@emo-search.herokuapp.com" # twitter return no email, so set dummy email address because of email wanne be unique.
    logger.info auth.to_yaml

    if authentication.present?
      user = authentication.user
    else
      if current_user.present?
        user = current_user
      else
        user = User.create!({
          password: Devise.friendly_token[0,20],
          username: auth.info.nickname,
          email: dummy_email,
          image_url: auth.info.image,
        })
        user.skip_confirmation!
      end
      user.authentications.create!({
        provider: "twitter",
        uid: auth.uid.to_s,
        token: auth.credentials.token,
        secret: auth.credentials.secret,
        image_url: auth.info.image
      })
    end
    return user
  end

  def self.find_for_facebook_oauth(auth, current_user = nil)
    authentication = Authentication.find_by_provider_and_uid("facebook", auth.uid.to_s)
    logger.info auth.to_yaml

    if authentication.present?
      user = authentication.user
    else
      if current_user.present?
        user = current_user
      elsif User.exists?(email: auth.info.email)
        user = User.find_by_email(auth.info.email)
      else
        user = User.create!({
          password: Devise.friendly_token[0,20],
          username: auth.info.nickname,
          email: auth.info.email,
          image_url: auth.info.image,
        })
        user.skip_confirmation!
      end
      user.authentications.create!({
        provider: "facebook",
        uid: auth.uid.to_s,
        token: auth.credentials.token,
        image_url: auth.info.image
      })
    end
    return user
  end

  # Skip password require validation if user have authentications
  def password_required?
    super && authentications.blank?
  end

  # Allow user to change password without current password if user have authentications
  def update_with_password(params, *options)
    if authentications.present?
      update_attributes(params, *options)
    else
      super
    end
  end
end
