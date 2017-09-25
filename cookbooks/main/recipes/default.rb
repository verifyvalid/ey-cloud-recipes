# You must add your packages to packages/attributes/packages.rb
include_recipe 'packages'

# install the aws_cli to download config files
include_recipe 'aws_cli'

# custom fonts
include_recipe 'fonts'

# add support for the wkhtmltopdf converter
include_recipe 'wkhtmltopdf'

# add emerge-based packages
include_recipe 'pdftk'
include_recipe 'clamav'

# Shared database config
include_recipe 'shared_database'

# Shared config including but not limited to: yodlee, quickbooks_online, and smtp settings.
include_recipe 'app_config'

include_recipe 'cron'

#include_recipe 'data_gather'

include_recipe 'custom_prompt'
