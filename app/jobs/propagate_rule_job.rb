class PropagateRuleJob < ActiveJob::Base
  queue_as :default

  def perform(rule_id)
    rule = Rule.find_by_id(rule_id)
    #if resource doesn't exist anymore just return
    return if(rule.nil?)
    #sleep(5)
    GcmDispatcher.send(["eXBg3J4J3Hw:APA91bGhc_WXop5pcpt3OBvaeGxIHaqz5nlvaOWoVFCPoAc2jtIvvvUuiGuNJ_OwX58NbnZyDX2jFGaLOAIAgGxVezEibKCK3p3g1g2l7DRPz78Z8-giwOEd4koUD2WVwW1bpsedbqUL"],
    rule.name)
    #todo check user entities
    #todo check user_group entities
    #todo for each user check devices that can use
    #todo
  end
end
