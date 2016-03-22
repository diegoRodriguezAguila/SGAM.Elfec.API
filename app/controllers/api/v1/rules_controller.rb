class Api::V1::RulesController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible

  #GET policies/:policy_id/rules
  def index
    policy = Policy.find_by(type: params[:policy_id])
    return head :not_found if policy.nil?
    raise Exceptions::SecurityTransgression unless policy.viewable_by? current_user
    render json: policy.rules, root: false, status: :ok
  end

  #POST policies/:policy_id/rules
  def create
    policy = Policy.find_by(type: params[:policy_id])
    return head :not_found if policy.nil?
    rule = policy.rules.create(rule_params)
    return render json: {errors: rule.errors.full_messages[0]}, status: :unprocessable_entity unless rule.errors.empty?
    render json: rule, status: :created, location: api_policy_rules_url(rule)
  end

  #DELETE policies/:policy_id/rules/:rule_id
  def destroy
  policy = Policy.find_by(type: params[:policy_id])
    return head :not_found if policy.nil?
    rule = policy.rules.where(id: HASHIDS.decode(params[:id])).first
    return head :not_found if rule.nil?
    Rule.destroy rule.id
    head :no_content
  end

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+:rule.to_s, Rails.configuration.ids_length)

  def rule_params
    params.require(:rule).permit(:action, :name, :description, :value, :exception)
  end

end
