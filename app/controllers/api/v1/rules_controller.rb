class Api::V1::RulesController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible

  #GET policies/:policy_id/rules
  def index
    policy = Policy.find_by(type: policy_id_param)
    return head :not_found if policy.nil?
    raise Exceptions::SecurityTransgression unless policy.viewable_by? current_user
    render json: policy.rules, include: request_includes, host: request.host_with_port, root: false, status: :ok
  end

  #POST policies/:policy_id/rules
  def create
    policy = Policy.find_by(type: policy_id_param)
    return head :not_found if policy.nil?
    rule = policy.rules.create(rule_params)
    return render json: {errors: rule.errors.full_messages[0]}, status: :unprocessable_entity unless rule.errors.empty?
    render json: rule, status: :created, location: api_policy_rules_url(rule)
  end

  #DELETE policies/:policy_id/rules/:rule_id
  def destroy
    policy = Policy.find_by(type: policy_id_param)
    return head :not_found if policy.nil?
    rule = policy.rules.where(id: HASHIDS.decode(params[:id])).first
    return head :not_found if rule.nil?
    Rule.destroy rule.id
    head :no_content
  end

  #region applies_to_entities

  #GET rules/:rule_id/applies_to_entities
  def show_applies_to_entities
    rule = Rule.find_by(id: HASHIDS.decode(params[:rule_id]))
    return head :not_found if rule.nil?
    # raise Exceptions::SecurityTransgression unless rule.viewable_by? current_user
    render json: rule.entities, host: request.host_with_port, root: false, status: :ok
  end

  #POST rules/:rule_id/applies_to_entities/:entity_ids
  def add_entities
    rule = Rule.find_by(id: HASHIDS.decode(params[:rule_id]))
    return head :not_found if rule.nil?
    users_to_add = User.where(username: entity_ids_params,
                              status: User.statuses[:enabled]) - rule.users
    user_groups_to_add = UserGroup.where(id: user_group_ids_params,
                              status: UserGroup.statuses[:enabled]) - rule.user_groups
    rule.users << users_to_add
    rule.user_groups << user_groups_to_add
    head :no_content
  end

  #DELETE rules/:rule_id/applies_to_entities/:entity_ids
  def remove_entities
    rule = Rule.find_by(id: HASHIDS.decode(params[:rule_id]))
    return head :not_found if rule.nil?
    users_to_del = User.where(username: entity_ids_params)
    user_groups_to_del = UserGroup.where(id: user_group_ids_params)
    rule.users = rule.users - users_to_del
    rule.user_groups = rule.user_groups - user_groups_to_del
    head :no_content
  end

  #endregion

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+:rule.to_s, Rails.configuration.ids_length)

  def rule_params
    params.require(:rule).permit(:action, :name, :description, :value, :exception)
  end

  def policy_id_param
    params.require(:policy_id)
  end

  def entity_ids_params
    params[:entity_ids].gsub(/\s+/, '').split(',')
  end

  def user_group_ids_params
    ug_params = []
    ug_hashids = Hashids.new(Rails.configuration.hashids.salt+:user_group.to_s, Rails.configuration.ids_length)
    entity_ids_params.each do |user_group_id|
      ug_params << ug_hashids.decode(user_group_id)
    end
    ug_params
  end

end
