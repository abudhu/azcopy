require 'chef/resource/lwrp_base'
class Chef
  class Resource
    class AZCopy < Chef::Resource::LWRPBase

      provides :azcopy

      self.resource_name = :azcopy

      actions :download, :download_if_missing
      default_action :download_if_missing

      attribute :key, kind_of: String, default: nil
      attribute :blob, kind_of: String, default: nil
      attribute :folder, kind_of: String, default: nil
      attribute :file, kind_of: Array, default: []
      attribute :destination, kind_of: String, default: nil
      attribute :ignore_journal, kind_of: [TrueClass, FalseClass], default: true

    end # AZCopy
  end # Resource
end # Chef
