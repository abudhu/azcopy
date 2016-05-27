module AZCopyLWRP
  module Helpers
    include Chef::DSL::IncludeRecipe

    def dotnet_installed?
      dotnet_array = []

      node['azcopy']['dotnet_release_versions'].each do |dotnet_release_version|
        dotnet_array.push(
          registry_data_exists?(
            'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full',
            {:name => 'Release', :type => :dword, :data => dotnet_release_version}
          )
        )

      end # Release_version loop

      package "Download DotNet 4.5" do
        source node['azcopy']['dotnet_url']
        installer_type :custom
        options '/q /norestart'
        action :install
        not_if {(dotnet_array.uniq).include?(true)}
      end # Package

    end # dotnet_installed

    def azcopy_installed?
      package "Download Azure Storage Tools" do
        source node['azcopy']['azcopy_url']
        installer_type :msi
        action :install
        not_if {::File.exists?(node['azcopy']['executable'])}
      end # Package

    end # AZcopy_installed



  end # Helpers
end # AZCopyLWRP
