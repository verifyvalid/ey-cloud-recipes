# TODO
# - rewrite the tmp cleanup find

cron 'tmp_file_cleanup' do
  action :create
  hour '3'
  user 'deploy'
  # mailto 'sysadmin@example.com'
  command %w{
    cd /data &&
    find . -maxdepth 2 -name "shared" |
    xargs -I {} find "{}" -maxdepth 1 -name tmp |
    xargs -I {} find "{}"  -maxdepth 1 -name "*.*" -ctime +2  -print0 |
    xargs -0 rm
  }.join(' ')
end

# This was previously only in production.  It looks like a 
cron 'tmp_check_file_cleanup' do
  action :create
  hour '3'
  user 'deploy'
  # mailto 'sysadmin@example.com'
  command %w{
    cd /data &&
    find . -maxdepth 2 -name "shared" |
    xargs -I {} find "{}" -maxdepth 1 -name tmp |
    xargs -I {} find "{}/checks"  -maxdepth 1 -name "*.*" -ctime +2 -print0 |
    xargs -0 rm
  }.join(' ')
end

# Before this can be uncommented, we need to address the fact that applications
# are named differently in the different environments.  Some translation table
# early in the chef recipes?  Whatever the short term solution, we ultimately
# need to consolidate our naming structure.  Get rid of dates in names and get
# product name out of places that it should be implied.

#cron 'daily_activity_report' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '1'
#  hour '0'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:environment][:framework_env]} '\\''Reports::DailyActivityReport.generate_24hr_activity_report'\\'''"
#end
#
#cron 'send_ach_activation_reminder' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '0'
#  hour '9'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''CheckingAccountActivation.send_ach_activation_reminder_email_notifications'\\'''"
#end
#
#cron 'send_no_ach_activation_reminder' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '1'
#  hour '9'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''CheckingAccountActivation.send_no_ach_activation_reminder_email_notifications'\\'''"
#end
#
#cron 'lockbox expire_outstanding' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '0'
#  hour '0'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''Lockbox.expire_outstanding'\\'''"
#end
#
#cron 'user send_welcome_emails' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' } # && @apps_list.include? 'verifyvalid'
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '0'
#  hour '12'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''User.send_welcome_emails'\\'''"
#end
#
#cron 'orderstat calculate_for_yesterday' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '30'
#  hour '1'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''OrderStat.calculate_for_yesterday'\\'''"
#end
#
#cron 'verifyvalid stats nightly' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '1'
#  hour '5'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && RAILS_ENV=#{node[:engineyard][:environment][:framework_env]} bundle exec rake verifyvalid:stats:nightly --silent'"
#end
#
#cron 'yodlee populate banks' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '10'
#  hour '1'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && RAILS_ENV=#{node[:engineyard][:environment][:framework_env]} bundle exec rake yodlee:populate_banks --silent'"
#end
#
#cron 'payee populate_metadata' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '0'
#  hour '8'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''VvPayee.populate_metadata'\\'''"
#end
#
#cron 'send_check_delivery_failure_notice' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '30'
#  hour '8'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''CheckDeliveryService.send_check_delivery_failure_notice'\\'''"
#end
#
#cron 'refresh_reporting_stats' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '0'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && RAILS_ENV=#{node[:engineyard][:environment][:framework_env]} bundle exec rake verifyvalid:stats:refresh_reporting_stats --silent'"
#end
#
#cron 'generate_usage_billing_order_service' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'verifyvalid' }
#  minute '0'
#  hour '23'
#  weekday '0'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/VerifyValid/current && bin/rails runner -e #{node[:engineyard][:environment][:framework_env]} '\\''GenerateUsageBillingOrderService.execute'\\'''"
#end
#
#cron 'rake tasks hourly' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'monitoring' }
#  minute '0'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/vv_monitoring/current && RAILS_ENV=#{node[:engineyard][:environment][:framework_env]} bundle exec rake tasks:hourly --silent'"
#end
#
#cron 'rake tasks daily' do
#  action :create
#  only_if { node[:instance_role] == 'app_master' }
#  only_if { node[:app_list].include? 'monitoring' }
#  minute '1'
#  hour '0'
#  user 'deploy'
#  command "/bin/bash -l -c 'cd /data/vv_monitoring/current && RAILS_ENV=#{node[:engineyard][:environment][:framework_env]} bundle exec rake tasks:daily --silent'"
#end
