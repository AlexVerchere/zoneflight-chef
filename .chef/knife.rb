require "yaml"

chef_user = ENV["CHEF_USER"] || ENV["USER"]

log_level                :info
log_location             STDOUT

node_name               chef_user
client_key              "#{File.dirname(__FILE__)}/#{chef_user}.pem"

#chef_server_url         'https://chef.zone-flight.local/organizations/zone-flight/'
chef_server_url         'https://163.5.245.201/organizations/zone-flight/'
ssl_verify_mode         :verify_none

cache_type              'BasicFile'
cache_options( :path => "#{File.dirname(__FILE__)}/checksums" )
cookbook_path [
  "#{File.dirname(__FILE__)}/../site-cookbooks/"
]

# knife backup configuration
knife[:chef_server_backup_dir] = "#{File.dirname(__FILE__)}/../"
data_bag_path File.dirname(__FILE__) + "/../data_bags"
