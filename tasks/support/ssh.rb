def sshlive(host, password = nil, script = nil)
  prefix = password ? "sshpass -p #{password}" : ""
  key = File.join(ROOT, "tasks", "support", "id_rsa")
  File.chmod(0400, key) # for good measure
  ssh = %{#{prefix} ssh -l root -i #{key} -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" -o "GlobalKnownHostsFile /dev/null"}
  if File.exist?(script)
    sh(%{cat #{script} | #{ssh} #{host} "bash -s"})
  elsif script
    sh(%{#{ssh} #{host} #{script}})
  else
    sh(%{#{ssh} #{host}})
  end
end
