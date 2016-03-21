class Api::V1::PoliciesController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible
  #GET policies/:id
  def show
    # searches by hashed id
    policy = Policy.find_by(type: params[:id])
    if policy.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless policy.viewable_by? current_user
      render json: policy, include: request_includes, host: request.host_with_port, status: :ok
    end
  end

  #GET policies
  def index
    raise Exceptions::SecurityTransgression unless Policy.are_viewable_by? current_user
    policies = Policy.where(policy_filter_params).order(sort_params_for(Policy))
    render json: policies,include: request_includes, host: request.host_with_port, root: false, status: :ok
  end

  private
  def policy_filter_params
    params.permit(:type, :name, :description, :status)
  end

end
