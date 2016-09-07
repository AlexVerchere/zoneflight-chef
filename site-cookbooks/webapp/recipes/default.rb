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

%w{zoneflight-api zoneflight-web}.each do |site|
    template "/etc/apache2/sites-available/#{site}.conf" do
        source "#{site}.conf.erb"
        mode 0644
        owner "root"
        group "root"
        notifies :run, "execute[apache2-graceful]"
        not_if "test -f /etc/apache2/sites-available/#{site}.conf"
    end

    link "/etc/apache2/sites-enabled/#{site}.conf" do
        to "/etc/apache2/sites-available/#{site}.conf"
        not_if "test -L /etc/apache2/sites-enabled/#{site}.conf"
        notifies :run, "execute[apache2-graceful]"
    end
end

file "/etc/apache2/sites-enabled/000-default.conf" do
    action :delete
    notifies :run, "execute[apache2-graceful]"
end

execute "apache2-graceful" do
    command "apache2ctl configtest && apache2ctl graceful"
    action :nothing
end

composer_project "/var/www/zoneflight-api" do
    dev false
    quiet true
    prefer_dist false
    not_if "test -L /var/www/zoneflight-api"
    action :install
end
