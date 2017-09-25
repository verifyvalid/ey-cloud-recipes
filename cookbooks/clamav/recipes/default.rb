package 'app-antivirus/clamav' do
  version '0.98.7'
  action :install
end

remote_file '/etc/clamd.conf' do
  source 'https://s3.amazonaws.com/verifyvalid_resources/clamav/YpQj2M7oWEdKgKsVtRjUwzTZebGb-clamd.conf'
  mode '0644'
end

remote_file '/etc/freshclam.conf' do
  source 'https://s3.amazonaws.com/verifyvalid_resources/clamav/L7zbUXu3qEJPPNZrNtLRYmCwZAXk-freshclam.conf'
  mode '0644'
end

# I don't believe this is needed since clamd handles this
# cron 'freshclam' do
#   action :create
#   minute '32'
#   hour '4'
#   user 'root'
#   command '/usr/bin/freshclam'
# end

service 'clamd' do
  action :restart
end
