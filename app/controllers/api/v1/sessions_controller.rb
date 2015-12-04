#encoding: UTF-8
class Api::V1::SessionsController < ApplicationController
  def create
    user_username = params[:session][:username]
    user_password = params[:session][:password]
    user = user_username.present? && User.find_by(username: user_username)
    if user && user.valid_password?(user_password)
      sign_in user, store: false
      #simple_token_generator calls automatically to ensure_authentication_token
      user.save
      render json: user, show_token: true, include_roles: true, include_permissions: true, status: :ok
    else
      render json: {errors: I18n.t(:'api.errors.session.invalid_credentials', :cascade => true)},
             status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(authentication_token: params[:id])
    if user.nil?
      head :bad_request
    else
      user.authentication_token = nil
      user.save
      head :no_content
    end
  end
end
