case node[:platform]
when "gentoo"
  package "app-admin/syslog-ng"

when "debian"
  package "rsyslog" do
    action :remove
  end

  package "syslog-ng"
end

directory "/etc/syslog-ng/conf.d" do
  action :delete
  recursive true
end

indexer_nodes = node.run_state[:nodes].select do |n|
  n[:tags].include?("splunk-indexer") rescue false
end

template "/etc/syslog-ng/syslog-ng.conf" do
  source "syslog-ng.conf"
  owner "root"
  group "root"
  mode "0640"
  notifies :restart, "service[syslog-ng]"
  variables :indexer_nodes => indexer_nodes
end

systemd_unit "syslog-ng.service"

service "syslog-ng" do
  action [:enable, :start]
end

include_recipe "syslog::logrotate"

if tagged?("nagios-client")
  nrpe_command "check_syslog" do
    command "/usr/lib/nagios/plugins/check_systemd syslog-ng.service /run/syslog-ng.pid /usr/sbin/syslog-ng"
  end

  nagios_service "SYSLOG" do
    check_command "check_nrpe!check_syslog"
    servicegroups "system"
    env [:testing, :development]
  end
end
