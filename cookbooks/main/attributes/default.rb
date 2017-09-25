default[:owner_name] = node[:users].first[:username]
default[:owner_pass] = node[:users].first[:password]

default[:app_list] = node[:engineyard][:environment][:apps].map { |app| app[:name].downcase }
