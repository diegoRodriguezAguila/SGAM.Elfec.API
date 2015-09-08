class Api::V1::UsersController < ApplicationController
  def show
    user = User.find_by(username: params[:id])
    if user.nil?
      head 404
    else
      render json: user.as_json, status: 200
    end
  end
end
