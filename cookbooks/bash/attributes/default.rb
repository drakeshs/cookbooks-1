default[:bash][:rcdir] = case platform
                         when "gentoo"
                           "/etc/bash"
                         when "mac_os_x"
                           "~/.bash"
                         end
