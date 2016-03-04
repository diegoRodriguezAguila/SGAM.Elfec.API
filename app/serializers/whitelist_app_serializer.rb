class WhitelistAppSerializer < ModelWithStatusSerializer
  attributes :package, :status
  self.root = false
end
