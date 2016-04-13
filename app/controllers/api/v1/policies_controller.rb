class Api::V1::PoliciesController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible
  #GET policies/:id
  def show
    # searches by type
    policy = Policy.find_by(type: params[:id])
    return head :not_found if policy.nil?
    raise Exceptions::SecurityTransgression unless policy.viewable_by? current_user
    render json: policy, include: includes_entities, host: request.host_with_port, status: :ok
  end

  #GET policies
  def index
    raise Exceptions::SecurityTransgression unless Policy.are_viewable_by? current_user
    policies = Policy.where(policy_filter_params).order(sort_params_for(Policy))
    includes = request_includes
    includes << "entity_type"
    render json: policies, include: includes_entities, host: request.host_with_port, root: false, status: :ok
  end

  private

  def policy_filter_params
    params.permit(:type, :name, :description, :status)
  end

  def includes_entities
    includes = request_includes
    includes << 'entity_type'
    includes
  end

end
