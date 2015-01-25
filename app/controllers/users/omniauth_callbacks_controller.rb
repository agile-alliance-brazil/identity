#encoding: UTF-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.omniauth_data'] = request.env['omniauth.auth'].reject{|k,v| k=='extra' || k=='credentials'}
      session['devise.omniauth_data']['info'] = session['devise.omniauth_data']['info'].select{|k, v| k=='email' || k == 'name'}

      redirect_to new_user_registration_url
    end
  end
end
