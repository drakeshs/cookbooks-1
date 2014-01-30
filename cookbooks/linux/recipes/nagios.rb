if nagios_client?
  include_recipe "nagios::client"

  nagios_service "PING" do
    check_command "check_ping!250.0,20%!500.0,60%"
    servicegroups "system"
    env [:staging, :testing, :development]
  end

  nrpe_command "check_load" do
    command "/usr/lib/nagios/plugins/check_load -w #{node[:cpu][:total]*3} -c #{node[:cpu][:total]*10}"
  end

  nagios_service "LOAD" do
    check_command "check_nrpe!check_load"
    servicegroups "system"
    env [:staging, :testing, :development]
  end

  nrpe_command "check_zombie_procs" do
    command "/usr/lib/nagios/plugins/check_procs -w 5 -c 10 -s Z"
  end

  nagios_service "ZOMBIES" do
    check_command "check_nrpe!check_zombie_procs"
    servicegroups "system"
    env [:staging, :testing, :development]
  end

  nrpe_command "check_total_procs" do
    command "/usr/lib/nagios/plugins/check_procs -w 300 -c 1000"
  end

  nagios_service "PROCS" do
    check_command "check_nrpe!check_total_procs"
    servicegroups "system"
    env [:staging]
  end

  nagios_plugin "check_mem"

  nrpe_command "check_mem" do
    if node[:memory][:total].to_i > 32*1024*1024
      command "/usr/lib/nagios/plugins/check_mem -C -u -w 95 -c 99"
    else
      command "/usr/lib/nagios/plugins/check_mem -C -u -w 80 -c 95"
    end
  end

  nagios_service "MEMORY" do
    check_command "check_nrpe!check_mem"
    servicegroups "system"
    env [:staging, :testing, :development]
  end

  nagios_plugin "check_raid"

  nrpe_command "check_raid" do
    command "/usr/lib/nagios/plugins/check_raid"
  end

  nagios_service "RAID" do
    check_command "check_nrpe!check_raid"
    servicegroups "system"
    env [:staging, :testing, :development]
  end

  mounts = node[:filesystem].values.map do |fs|
    fs[:mount] if fs[:fs_type] && fs[:mount] && File.directory?(fs[:mount])
  end.compact.map do |mount|
    "-p #{mount}"
  end.join(' ')

  nrpe_command "check_disks" do
    command "/usr/lib/nagios/plugins/check_disk -w 10% -c 5% #{mounts}"
  end

  nagios_service "DISKS" do
    check_command "check_nrpe!check_disks"
    notification_interval 15
    servicegroups "system"
    env [:staging, :testing, :development]
  end

  nrpe_command "check_swap" do
    command "/usr/lib/nagios/plugins/check_swap -w 75% -c 50%"
  end

  nagios_service "SWAP" do
    check_command "check_nrpe!check_swap"
    notification_interval 180
    servicegroups "system"
    env [:staging, :testing, :development]
  end

  sudo_rule "nagios-ethtool" do
    user "nagios"
    runas "root"
    command "NOPASSWD: /usr/sbin/ethtool"
    command "NOPASSWD: /sbin/ethtool" if debian_based?
  end

  nagios_plugin "check_link_usage"

  nrpe_command "check_link_usage" do
    command "/usr/lib/nagios/plugins/check_link_usage"
  end

  nagios_service "LINK" do
    check_command "check_nrpe!check_link_usage"
    servicegroups "system"
    check_interval 10
    env [:staging, :testing, :development]
  end

  execute "check_link_usage" do
    command "/usr/lib/nagios/plugins/check_link_usage"
    creates "/tmp/.check_link_usage.eth0:"
    user "nagios"
    group "nagios"
  end
end
