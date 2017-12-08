#
# Cookbook Name:: app_config
# Recipe:: default
#

#node[:engineyard][:environment][:apps].each do |app|
#  config_files = [
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/fa2HnSlMyHkvm6qLIP3M_qbo.staging.yml',
#      filename: 'quickbooks_online.yml',
#      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/HATtn9kJDzCnVZ6dTXjZ_yodlee.staging.yml',
#      filename: 'yodlee.yml',
#      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/wPUqhGgiydJP9ztFYBP_smtp_settings.staging.yml',
#      filename: 'smtp_settings.yml',
#      apps: ['VerifyValid', 'verifyvalid', 'vv_support', 'vv_registrar', 'Registrar']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/microbilt.staging_yLCWSF5gZuIw9UeJbGAw.yml',
#      filename: 'microbilt.yml',
#      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/keys.staging_X6FqTMLAofAI6PbMuJFLpQj.yml',
#      filename: 'keys.yml',
#      apps: ['VerifyValid', 'verifyvalid']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/api.staging_yLCWSF5gZuIw9UeJbGAw.yml',
#      filename: 'api.yml',
#      apps: ['Registrar', 'registrar', 'vv_onboard', 'monitoring']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/verifyvalid.staging_JxoCcxsDxIeNDiFicybw.yml',
#      filename: 'verifyvalid.yml',
#      apps: ['donations']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/maxmind.staging_82sklasSJa920a.yml',
#      filename: 'maxmind.yml',
#      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
#    },
#    {
#      source: 'https://s3.amazonaws.com/verifyvalid_resources/secrets.staging_Dz7yR3fbfKAqYyu.yml',
#      filename: 'secrets.yml',
#      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
#    }
#  ]

  # only run the config needed for the app
  # config_files is modified between runs, so re-define it
#  configs = config_files.keep_if { |config| config[:apps].include?(app[:name]) }
#  next if configs.empty?
#
#  configs.each do |config_values|
#    remote_file "/data/#{app[:name]}/shared/config/#{config_values[:filename]}" do
#      source config_values[:source]
#      mode '0644'
#      only_if { Dir.exists?("/data/#{app[:name]}/shared/config") }
#    end
#  end
#end

account_level_env = node[:engineyard][:environment][:framework_env] == 'production' ? 'production' : 'staging' 
env_bucket_name = "#{account_level_env}-echecks"

# =================================================
# Hijacked code for use in migrating from obfuscated S3 URLs to EY S3 private buckets
# =================================================

node[:engineyard][:environment][:apps].each do |app|
  if ['verifyvalid', 'monitoring'].include?(app[:name].downcase)
    execute "add_whenever_cronjobs_#{app[:name]}" do
      user "deploy"
      cwd "/data/#{app[:name]}/current"
      command "bundle exec whenever --set environment=#{node[:engineyard][:environment][:framework_env]} --update-crontab #{app[:name]}_#{node[:engineyard][:environment][:framework_env]}"
      only_if { node[:instance_role] == 'app_master' }
    end
  end

  config_files = [
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'quickbooks_online.yml',
      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'yodlee.yml',
      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'smtp_settings.yml',
      apps: ['VerifyValid', 'verifyvalid', 'vv_support', 'vv_monitoring', 'monitoring', 'vv_registrar', 'Registrar']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'microbilt.yml',
      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'keys.yml',
      apps: ['VerifyValid', 'verifyvalid']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'api.yml',
      apps: ['Registrar', 'vv_registrar', 'vv_onboard', 'monitoring', 'vv_monitoring']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'verifyvalid.yml',
      apps: ['donations']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'maxmind.yml',
      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
    },
    {
      shared: true,
      filepath: "/data/#{app[:name]}/shared/config",
      filename: 'secrets.yml',
      apps: ['VerifyValid', 'verifyvalid', 'vv_support']
    }
  ]

  # only run the config needed for the app
  # config_files is modified between runs, so re-define it
  configs = config_files.keep_if { |config| config[:apps].include?(app[:name]) }
  next if configs.empty?

  configs.each do |config_values|
    file "#{config_values[:filepath]}/#{config_values[:filename]}" do
      mode '0644'
      action :nothing
      only_if { Dir.exists?("/data/#{app[:name]}/shared/config") }
    end

    download_location = config_values[:shared] ? 'shared' : node[:engineyard][:environment][:name]

    execute 'download_config_files' do
      cwd config_values[:filepath]
      command "aws s3 cp s3://#{env_bucket_name}/#{download_location}/#{config_values[:filename]} ."
      notifies :touch, "file[#{config_values[:filepath]}/#{config_values[:filename]}]", :immediate
      only_if { Dir.exists?("/data/#{app[:name]}/shared/config") }
    end
  end
end

# Copy the encryption keys from S3
directory '/data/rails/keys' do
  mode 0770
  recursive true
  owner 'deploy'
  group 'deploy'
  action :create
end

["verify_valid_#{account_level_env}.iv", "verify_valid_#{account_level_env}.key"].each do |encryption_file|
  file "/data/rails/keys/#{encryption_file}" do
    owner 'deploy'
    group 'deploy'
    mode '0440'
    action :nothing
    only_if { Dir.exists?("/data/rails/keys") }
  end

  execute 'download_config_files' do
    cwd '/data/rails/keys'
    command "aws s3 cp s3://#{env_bucket_name}/shared/keys/#{encryption_file} /data/rails/keys/"
    notifies :touch, "file[/data/rails/keys/#{encryption_file}]", :immediate
    only_if { Dir.exists?('/data/rails/keys') }
  end
end
