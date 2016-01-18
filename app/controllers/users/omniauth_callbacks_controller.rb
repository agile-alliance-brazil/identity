# encoding: UTF-8
module Users
  # Callback controller to handle omniauth returns with token
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    USER_DATA = %w(email name first_name last_name username nickname).freeze

    def facebook
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        redirect_to_success(@user, kind: 'Facebook')
      else
        session[User::SESSION_DATA_KEY] =
          clean_auth_data(request.env['omniauth.auth'])

        redirect_to new_user_registration_url
      end
    end

    def twitter
      session[User::SESSION_DATA_KEY] =
        clean_auth_data(request.env['omniauth.auth'])

      redirect_to new_user_registration_url
    end

    private

    def redirect_to_success(user, options = {})
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, options) if is_navigational_format?
    end

    def clean_auth_data(data)
      {
        provider: data['provider'],
        uid: data['uid'],
        info: (data['info'] || {}).select do |key, _value|
          USER_DATA.include?(key)
        end
      }
    end
  end
end
