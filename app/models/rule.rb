class Rule < ActiveRecord::Base
  enum action: {permit: 'permit',
                deny: 'deny'}
  enum status: [:disabled, :enabled]
  validates_presence_of :policy, :action, :name, :value
  validates_uniqueness_of :name, scope: :policy
  belongs_to :policy
  has_many :applies_to_entities, foreign_key: 'rule_id', class_name: 'EntityRule', dependent: :destroy
  has_many :users, through: :applies_to_entities, source: :entity, source_type: 'User'
  has_many :user_groups, through: :applies_to_entities, source: :entity, source_type: 'UserGroup'

  def entities
    entity_list = []
    users.each { |u| entity_list<<u }
    user_groups.each { |ug| entity_list<<ug }
    entity_list
  end

  # Generates the plain list of all users
  # that this rule applies to, thus, flattens
  # the users that are members of groups
  # @return [Array]
  def plain_users
    all_users = Set[]
    all_users << users.to_set
    all_users << user_groups.collect(&:members).flatten.to_set
    all_users.flatten.to_a
  end

  #
  # Gets the value pattern
  #
  # @return [Regexp] pattern of the value of the rule
  #
  def value_pattern
    return /.*/i if (value.nil?)
    string_to_pattern value
  end

  #
  # Gets the exception pattern
  #
  # @return [Regexp] pattern of the exception of the rule
  #
  def exception_pattern
    return /(?!.*)/i if (exception.nil?)
    string_to_pattern exception
  end

  #
  # Analiza si es que el valor esta permitido segun el tipo y
  # las condiciones de la regla,
  # depende de las variables {@link #action},
  # {@link #value} y {@link #exception}
  #
  # @param [String] value valor a verificar
  # @return [Bool] true si el valor esta permitido por la regla
  #
  def is_permitted?(value)
    value = '' if (value.nil?)
    negate = self.deny?
    p 'value pattern: '+value_pattern.to_s
    #p 'exception pattern: '+exception_pattern.to_s
    val_match = value_pattern.match value
    exc_match = !(exception_pattern.match value)
    negate ^ (val_match && exc_match)
  end

  ##
  # Verifica si un valor cumple con al menos una de las reglas
  #
  # @param [String] value valor
  # @param [Array] rules reglas
  # @return [Bool] true si el valor cumple con al
  # menos una de las reglas, false en caso contrario
  #
  def self.is_permitted?(value, rules)
    permitted = true
    rules.each do |rule|
      permitted = rule.is_permitted?(value)
      break if permitted
    end
    permitted
  end

  private

  # Converts regex fro string value
  # @param [String] val
  # @return [Regexp] regex
  def string_to_pattern(val)
    pattern = val.gsub(',', '|').gsub(';', '|')
                  .gsub('.', '\\.').gsub('*', '.*').gsub('%', '.*')
                  .gsub('/[-[\\]{end+?\\^$|#\\s]/g', '\\$&')
    Regexp.new '^('+pattern+')$'
  end

end
