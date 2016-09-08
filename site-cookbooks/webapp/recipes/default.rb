#
# Cookbook Name:: webapp
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "composer::default"

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
    git "/var/www/#{site}" do
        repository "git://github.com/ZoneFlight/#{site}.git"
        reference "master"
        action :sync
    end

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
    action :install
end


execute "mysql-zoneflight" do
    command "mysql -uroot --execute \"CREATE DATABASE zoneflight\""
    notifies :run, "execute[mysql-create-table]"
    not_if do
        File.exist?("/var/lib/mysql/zoneflight")
    end
end

execute "mysql-create-table" do
    command "mysql -uroot zoneflight < /var/www/zoneflight-api/bin/database.sql"
    notifies :run, "execute[mysql-import-table]"
end

execute "mysql-import-table" do
    command "APPLICATION_ENV=development /var/www/zoneflight-api/bin/import_airports.php"
    action :nothing
end
