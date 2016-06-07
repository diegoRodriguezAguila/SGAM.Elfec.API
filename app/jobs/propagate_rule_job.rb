class PropagateRuleJob < ActiveJob::Base
  queue_as :default

  def perform(rule_id)
    rule = Rule.find_by_id(rule_id)
    #if resource doesn't exist anymore just return
    return if(rule.nil?)
    GcmDispatcher.send_rule(["eXBg3J4J3Hw:APA91bGhc_WXop5pcpt3OBvaeGxIHaqz5nlvaOWoVFCPoAc2jtIvvvUuiGuNJ_OwX58NbnZyDX2jFGaLOAIAgGxVezEibKCK3p3g1g2l7DRPz78Z8-giwOEd4koUD2WVwW1bpsedbqUL"],
    rule.name)
    p "All users: #{rule.plain_users.map{|u| u.username}}"
    #todo for each user check devices that can use
    #todo
  end
end
