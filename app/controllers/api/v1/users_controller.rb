class Api::V1::UsersController < ApplicationController
  def show
    user = User.find_by(username: params[:id])
    if user.nil?
      head 404
    else
      render json: user, status: 200
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
