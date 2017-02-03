#encoding: UTF-8
class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:username], params[:password])
    return render_error(command.errors, :unauthorized) unless command.success?
    render json: AuthorizationToken.new(command.result)
=begin
    user_username = params[:session][:username]
    user_password = params[:session][:password]
    user = user_username.present? && User.find_by(username: user_username)
    return render json: {errors: I18n.t(:'api.errors.session.invalid_credentials')},
                  status: :unprocessable_entity unless user &&
        user.valid_password?(user_password)
    sign_in user, store: false
    #simple_token_generator calls automatically to ensure_authentication_token
    user.save
    render json: user, show_token: true, include: %w(roles permissions), host: request.host_with_port, status: :ok
=end
  end

  def destroy
    user = User.find_by(authentication_token: params[:id])
    return head :bad_request if user.nil?
    sign_out user
    user.authentication_token = nil
    user.save
    head :no_content
  end
end
