#encoding: UTF-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  USER_DATA = ['email', 'name', 'first_name', 'last_name', 'username', 'nickname']
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session[User::SESSION_DATA_KEY] = clean_auth_data(request.env['omniauth.auth'])

      redirect_to new_user_registration_url
    end
  end
  def twitter
    session[User::SESSION_DATA_KEY] = clean_auth_data(request.env['omniauth.auth'])

    redirect_to new_user_registration_url
  end

  private
  def clean_auth_data(data)
    {
      provider: data['provider'],
      uid: data['uid'],
      info: (data['info']||{}).select{|key, value| USER_DATA.include?(key)}
    }
  end
end
