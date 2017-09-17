# Controller to list users and show a specific one
class UsersController < ApplicationController
  def index; end

  def show
    @user = resource
  end

  def me
    @user = current_user
    render :show
  end

  def resource_class
    User
  end

  def resource
    resource_class.find(params[:id])
  end
end
