class PropagateRuleJob < ActiveJob::Base
  queue_as :default

  def perform(rule_id)
    rule = Rule.find_by_id(rule_id)
    #if resource doesn't exist anymore just return
    return if(rule.nil?)
    FcmDispatcher.send_rule(["cNdBH1LGywU:APA91bH4fWf1tjJXCOEttH0WwZ2lurMR2zJv3gux-pQbj2Akt18R-cB_tnJTWL-mS_2QPnJohbpnqvvRQZZPJl4_mXVXdLrh4DtuAXJGQMqFmJCwT3am0k1JLmRHcgYG2iihvn5bN3Dq"],
    rule.name)
    p "All users: #{rule.plain_users.map{|u| u.username}}"
    #todo for each user check devices that can use
    #todo
  end
end
