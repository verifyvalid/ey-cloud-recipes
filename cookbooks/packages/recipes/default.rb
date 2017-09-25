#
# Cookbook Name:: packages
# Recipe:: default
#

node[:v2][:packages].each do |package|
  enable_package package[:name] do
    version package[:version]
    override_hardmask true
  end

  package package[:name] do
    version package[:version]
    action :install
  end
end
