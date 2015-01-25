#encoding: UTF-8
class Users::RegistrationsController < Devise::RegistrationsController
  def new
    data = session['devise.omniauth_data'] || {}
    @user = User.from_auth_info(data.with_indifferent_access[:info])
  end
end
