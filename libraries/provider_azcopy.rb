require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class AZCopy < Chef::Provider::LWRPBase
      include AZCopyLWRP::Helpers

      provides :azcopy if defined?(provides)

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :download do
        dotnet_installed?
        azcopy_installed?
        download_file(
          new_resource.key,
          new_resource.blob,
          new_resource.folder,
          new_resource.file,
          new_resource.destination,
          new_resource.ignore_journal,
          :download
        )
      end

      action :download_if_missing do
        dotnet_installed?
        azcopy_installed?
        download_file(
          new_resource.key,
          new_resource.blob,
          new_resource.folder,
          new_resource.file,
          new_resource.destination,
          new_resource.ignore_journal,
          :download_if_missing
        )
      end

    end # AZCopy
  end # Provider
end # Chef
