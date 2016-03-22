class Api::V1::PoliciesController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible
  #GET policies/:id
  def show
    # searches by type
    policy = Policy.find_by(type: params[:id])
    return head :not_found if policy.nil?
    raise Exceptions::SecurityTransgression unless policy.viewable_by? current_user
    render json: policy, include: request_includes, host: request.host_with_port, status: :ok
  end

  #GET policies
  def index
    raise Exceptions::SecurityTransgression unless Policy.are_viewable_by? current_user
    policies = Policy.where(policy_filter_params).order(sort_params_for(Policy))
    render json: policies,include: request_includes, host: request.host_with_port, root: false, status: :ok
  end

  #region rules

  def show_rules
    policy = Policy.find_by(type: params[:policy_id])
    return head :not_found if policy.nil?
    raise Exceptions::SecurityTransgression unless policy.viewable_by? current_user
    render json: policy.rules, root: false, status: :ok
  end

  #POST policies/:policy_id/rules
  def add_rule
    policy = Policy.find_by(type: params[:policy_id])
    return head :not_found if policy.nil?
    rule = policy.rules.create(rule_params)
    return render json: {errors: rule.errors.full_messages[0]}, status: :unprocessable_entity unless rule.errors.empty?
    render json: rule, status: :created, location: api_policy_url(rule)
  end

  #DELETE policies/:policy_id/rules/:rule_id
  def delete_rule
    policy = Policy.find_by(type: params[:policy_id])
    return head :not_found if policy.nil?
    rule = policy.rules.where(id: HASHIDS.decode(params[:rule_id])).first
    return head :not_found if rule.nil?
    Rule.destroy rule.id
    head :no_content
  end

  #endregion

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+:rule.to_s, Rails.configuration.ids_length)

  def policy_filter_params
    params.permit(:type, :name, :description, :status)
  end

  def rule_params
    params.require(:rule).permit(:action, :name, :description, :value, :exception)
  end

end
