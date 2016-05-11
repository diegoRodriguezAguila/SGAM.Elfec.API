module RulesNotifier

  # propagates the rules to the interested
  # users and devices
  # @param [Rule] rule
  def self.propagate_rule(rule)
    PropagateRuleJob.perform_later(rule.id)
  end
end