#
# Cookbook Name:: future-pipeline
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# Plan:
# Get Docker DTR Cert
#curl -k https://$UCP_HOST/ca > ucp-ca.pem
#remote_file "#{Chef::Config[:file_cache_path]}/dtr.pem" do
#    source "http://#{node['dtrhost']}/ca"
#    mode '0644'
#end

directory "/etc/docker/certs.d/" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


directory "/etc/docker/certs.d/#{node['dtrhost']}/" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'get_dtr_cert' do
  command "curl -k https://#{node['dtrhost']}/ca > /etc/docker/certs.d/#{node['dtrhost']}/dtr.crt"
  not_if { File.exist?("/etc/docker/certs.d/#{node['dtrhost']}/dtr.crt") }
end

service 'docker' do
  action :restart
end


# Push that to a databag
# mkdir
# install
# restart engine.
# docker login works.
