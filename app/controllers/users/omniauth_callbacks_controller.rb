#encoding: UTF-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  FACEBOOK_KEYS = ['provider', 'uid', 'info']
  USER_DATA = ['email', 'name', 'first_name', 'last_name', 'username']
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session[User::SESSION_DATA_KEY] = request.env['omniauth.auth'].select do |key, value|
        FACEBOOK_KEYS.include?(key)
      end
      if info = session[User::SESSION_DATA_KEY]['info']
        session[User::SESSION_DATA_KEY]['info'] = info.select do |key, value|
          USER_DATA.include?(key)
        end
      end

      redirect_to new_user_registration_url
    end
  end
end
