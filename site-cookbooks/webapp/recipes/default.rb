#
# Cookbook Name:: webapp
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:webapp][:webapp_packages].each do |name|
    package name do
        action :install
    end
end

node[:webapp][:webapp_mods].each do |mod|
    execute "enable_mods_#{mod}" do
            command "a2enmod #{mod}"
            action :run
            not_if "test -L /etc/apache2/mods-enabled/#{mod}.load"
        end
end
