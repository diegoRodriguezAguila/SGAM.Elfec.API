class Api::V1::SessionsController < ApplicationController
  def create
    user_username = params[:session][:username]
    user_password = params[:session][:password]
    user = user_username.present? && User.find_by(username: user_username)
    if user && user.valid_password?(user_password)
      sign_in user, store: false
      #simple_token_generator calls automatically to ensure_authentication_token
      user.save
      render json: user, status: 200
    else
      render json: {errors: "Usuario o password incorrectos!"}, status: 422
    end
  end

  def destroy
    user = User.find_by(authentication_token: params[:id])
    if user.nil?
      head 400
    else
      user.authentication_token = nil
      user.save
      head 204
    end
  end
end
