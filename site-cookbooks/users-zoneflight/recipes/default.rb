#
# Cookbook Name:: users-zoneflight
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "users"

users_manage 'sysadmin' do
  action [:create, :remove]
  data_bag 'users'
end
