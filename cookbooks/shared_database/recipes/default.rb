# Configure environment and app specific database names as needed
shared_database = {
  'production' => { 'vv_support' => 'VerifyValid' },
  'staging' => { 'vv_support' => 'verifyvalid' },
  'staging_2013' => { 'vv_support' => 'verifyvalid' },
  'training_2013' => { 'vv_support' => 'verifyvalid' },
  'training' => { 'vv_support' => 'verifyvalid' },
  'preproduction' => { 'vv_support' => 'verifyvalid' }
}

current_environment = node[:environment][:framework_env]
node[:engineyard][:environment][:apps].each do |app|
  # set the target database to the value within shared_database if able, otherwise defaults to the app name
  target_database = shared_database[current_environment][app[:name]] if shared_database[current_environment]
  target_database ||= app[:name]

  if Dir.exist?("/data/#{app[:name]}/shared/config/")
    template "/data/#{app[:name]}/shared/config/database.yml" do
      source 'database.yml.erb'
      owner node[:users][0][:username]
      group node[:users][0][:username]
      mode 0644
      variables({
        environment: node[:environment][:framework_env],
        adapter: 'mysql2',
        database: target_database,
        username: node[:users][0][:username],
        password: node[:users][0][:password],
        host: node[:db_host]
      })
    end
  end
end
