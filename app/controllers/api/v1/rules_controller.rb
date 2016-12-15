class Api::V1::RulesController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible

  #GET policies/:policy_id/rules
  def index
    policy = Policy.find_by(type: policy_id_param)
    return head :not_found if policy.nil?
    raise Exceptions::SecurityTransgression unless policy.viewable_by? current_user
    render json: policy.rules, include: request_includes, host: request.host_with_port,
           root: false, status: :ok
  end

  #POST policies/:policy_id/rules
  def create
    policy = Policy.find_by(type: policy_id_param)
    return head :not_found if policy.nil?
    rule_attr = rule_params
    rule_attr[:policy] = policy
    rule = Rule.new(rule_attr)
    raise Exceptions::SecurityTransgression unless rule.creatable_by?(current_user)
    users_to_add = User.where(username: entity_ids_params,
                              status: User.statuses[:enabled])
    user_groups_to_add = UserGroup.where(id: user_group_ids_params,
                                         status: UserGroup.statuses[:enabled])
    rule.users << users_to_add
    rule.user_groups << user_groups_to_add
    return render json: {errors: rule.errors.full_messages[0]},
                  status: :unprocessable_entity unless rule.save
    render json: rule, include: %w(entities entity_type), host: request.host_with_port,
           status: :created, location: api_policy_rules_url(rule)
  end

  #PATCH rules/:rule_id
  def update
    # searches by hashed id
    rule = Rule.find_by(id: HASHIDS.decode(params[:id]))
    return head :not_found if rule.nil?
    raise Exceptions::SecurityTransgression unless rule.updatable_by?(current_user)
    rule.assign_attributes(rule_params)
    return render json: {errors: rule.errors.full_messages[0]},
                  status: :unprocessable_entity unless rule.save
    render json: rule, include: %w(entities entity_type), host: request.host_with_port,
           status: :ok, location: [:api, rule]
  end

  #DELETE policies/:policy_id/rules/:rule_id
  def destroy
    policy = Policy.find_by(type: policy_id_param)
    return head :not_found if policy.nil?
    rule = policy.rules.where(id: HASHIDS.decode(params[:id])).first
    return head :not_found if rule.nil?
    raise Exceptions::SecurityTransgression unless rule.deletable_by?(current_user)
    Rule.destroy rule.id
    head :no_content
  end

  #DELETE policies/:policy_id/rules
  def bulk_destroy
    policy = Policy.find_by(type: policy_id_param)
    return head :not_found if policy.nil?
    raise Exceptions::SecurityTransgression unless Rule.are_deletable_by?(current_user)
    rule_ids = rule_ids_params
    rules = policy.rules.where(id: rule_ids)
    return render json: {errors:
                             I18n.t(:'api.errors.rule.delete_entities')},
                  status: :bad_request if rules.empty? || rules.size < rule_ids.size
    rules.destroy_all
    head :no_content
  end

  #region applies_to_entities

  #GET rules/:rule_id/entities
  def show_entities
    rule = Rule.find_by(id: HASHIDS.decode(params[:rule_id]))
    return head :not_found if rule.nil?
    # raise Exceptions::SecurityTransgression unless rule.viewable_by? current_user
    render json: rule.entities, host: request.host_with_port, include: ['entity_type'], root: false, status: :ok
  end

  #POST rules/:rule_id/entities/:entity_ids
  def add_entities
    rule = Rule.find_by(id: HASHIDS.decode(params[:rule_id]))
    return head :not_found if rule.nil?
    users_to_add = User.where(username: entity_ids_params,
                              status: User.statuses[:enabled]) - rule.users
    user_groups_to_add = UserGroup.where(id: user_group_ids_params,
                                         status: UserGroup.statuses[:enabled]) - rule.user_groups
    return head :not_modified if users_to_add.empty? && user_groups_to_add.empty?
    rule.users << users_to_add
    rule.user_groups << user_groups_to_add
    # RulesNotifier.propagate_rule(rule)
    render json: rule, include: %w(entities entity_type), host: request.host_with_port,
           status: :ok, location: [:api, rule]
  end

  #DELETE rules/:rule_id/entities/:entity_ids
  def remove_entities
    rule = Rule.find_by(id: HASHIDS.decode(params[:rule_id]))
    return head :not_found if rule.nil?
    users_to_del = User.where(username: entity_ids_params)
    user_groups_to_del = UserGroup.where(id: user_group_ids_params)
    return head :not_modified if users_to_del.empty? && user_groups_to_del.empty?
    rule.users = rule.users - users_to_del
    rule.user_groups = rule.user_groups - user_groups_to_del
    render json: rule, include: %w(entities entity_type), host: request.host_with_port,
           status: :ok, location: [:api, rule]
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

  def rule_ids_params
    params.require(:ids)
    undecoded_ids = (params[:ids].is_a? Array) ? params[:ids] : params[:ids].gsub(/\s+/, '').split(',')
    ids = []
    undecoded_ids.each { |id| ids << HASHIDS.decode(id) }
    ids.flatten
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
