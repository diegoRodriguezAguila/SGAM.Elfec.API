#encoding: UTF-8
class Api::V1::UsersController < ApplicationController
  def show
    user = User.find_by(username: params[:id])
    if user.nil?
      head 404
    else
      render json: user, status: :ok
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created, location: [:api, user]
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
