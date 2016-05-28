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

    def delete_journal
      current_user = `whoami`
      current_user = (current_user.split('\\')[1]).strip

      # This actually deletes the AZCopy folder as well, which is a bummer
      directory "Delete Journal Entries" do
        path "#{node['azcopy']['journal_path'][0]}#{current_user}#{node['azcopy']['journal_path'][1]}"
        recursive true
        action :delete
        not_if {Dir[("#{node['azcopy']['journal_path'][0]}#{current_user}#{node['azcopy']['journal_path'][1]}*").gsub("\\", "/")].empty?}
      end

      # So in the event we delete it, lets recreate it (just in case)
      directory "Recreate Journal Folder" do
        path "#{node['azcopy']['journal_path'][0]}#{current_user}#{node['azcopy']['journal_path'][1]}"
        action :create
      end

    end # Delete_journal

    def download_file(key,blob,folder,file,destination,journal,guard_type)

      if journal
        delete_journal
      end

      directory "Validating Destination Directory" do
        path destination
        recursive true
        action :create
      end

      file.each do |current_file|
        if current_file.class == Hash
          # We are renaming items as we download them
          current_file.each do |remote_name, dest_name|

            ruby_block "Backup Remote File if exists on Local machine" do
              block do
                if (File.exists?("#{destination}\\#{remote_name}"))
                  Chef::Log.info("Renaming #{remote_name} to .old as it exists at #{destination}")
                  File.rename("#{destination}\\#{remote_name}", "#{destination}\\#{remote_name}.old")
                end
              end
              not_if {guard_type == :download_if_missing && File.exists?("#{destination}#{remote_name}")}
            end # Ruby Block

            ruby_block "Backup Destination File if exists on Local machine" do
              block do
                if (File.exists?("#{destination}\\#{dest_name}"))
                  Chef::Log.info("Renaming #{dest_name} to .old as it exists at #{destination}")
                  File.rename("#{destination}\\#{dest_name}", "#{destination}\\#{dest_name}.old")
                end
              end
            end # Ruby Block

            powershell_script "Downloading: #{remote_name} From: #{blob}\\#{folder} to: #{destination}" do
              code <<-EOH
                "#{node['azcopy']['executable']}" /Source:#{blob}/#{folder} /Dest:#{destination} /SourceKey:"#{key}" /Pattern:"#{remote_name}"
              EOH
              not_if{guard_type == :download_if_missing && File.exists?("#{destination}#{remote_name}")}
            end

            powershell_script "Renaming #{remote_name} to: #{dest_name}" do
              code <<-EOH
                Rename-Item -path #{destination}\\#{remote_name} -newname #{dest_name} -force
              EOH
            end

            # Delete those backups
            ruby_block "Remove Backup files" do
              block do
                if (File.exists?("#{destination}\\#{dest_name}.old") || File.exists?("#{destination}\\#{remote_name}.old") )
                  begin
                    File.delete("#{destination}\\#{dest_name}.old")
                    File.delete("#{destination}\\#{remote_name}.old")
                  rescue
                    # Empty Rescue since we are throwing away Ruby's error if the file might not exists
                  end # Begin / Rescue
                end
              end
            end # Ruby Block

          end # current_file loop
        else
          # Download the file!
          powershell_script "Downloading: #{current_file} From: #{blob}\\#{folder} to: #{destination}" do
            code <<-EOH
              "#{node['azcopy']['executable']}" /Source:#{blob}/#{folder} /Dest:#{destination} /SourceKey:"#{key}" /Pattern:"#{current_file}"
            EOH
            not_if {guard_type == :download_if_missing && File.exists?("#{destination}#{current_file}")}
          end
        end # If class = hash
      end # File Loop
    end # Download_file

  end # Helpers
end # AZCopyLWRP
