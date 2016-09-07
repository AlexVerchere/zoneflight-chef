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

%w{zoneflight-api zoneflight-web}.each do |app|
    template "/etc/apache2/sites-available/#{app}.conf" do
        source "#{app}.conf.erb"
        mode 0644
        owner "root"
        group "root"
        notifies :run, "execute[apache2-graceful]"
        not_if "test -f /etc/apache2/sites-available/#{app}.conf"
    end

    link "/etc/apache2/sites-enabled/#{app}.conf" do
        to "/etc/apache2/sites-available/#{app}.conf"
        not_if "test -L /etc/apache2/sites-enabled/#{app}.conf"
        notifies :run, "execute[apache2-graceful]"
    end
end
