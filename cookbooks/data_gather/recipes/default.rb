#
# Cookbook Name:: data_gather
# Recipe:: default
#
file '/home/deploy/data_file' do
  owner node[:owner_name]
  group node[:owner_name]
  only_if { node[:engineyard][:environment][:framework_env] != 'production' }
  content "
    Applications: #{node[:app_list].join(' ')}
    Engineyard Environment: #{node[:engineyard][:environment][:name]}
    Framework Environment: #{node[:engineyard][:environment][:framework_env]}
    Instance Role: #{node[:instance_role]}
    Instance Role app_master: #{node[:instance_role] == 'app_master'}
"
end
