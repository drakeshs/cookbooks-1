# base packages
if gentoo?
  node.set[:packages] = %w(
    app-admin/apache-tools
    app-admin/pwgen
    app-admin/pydf
    app-admin/sysstat
    app-arch/atool
    app-arch/xz-utils
    app-misc/colordiff
    app-misc/mc
    app-shells/bash-completion
    app-text/dos2unix
    app-text/tree
    dev-libs/icu
    dev-libs/libffi
    dev-libs/libxml2
    dev-libs/libxslt
    dev-libs/libyaml
    dev-ruby/haml
    dev-ruby/syslogger
    dev-util/strace
    mail-client/mailx
    net-analyzer/bwm-ng
    net-analyzer/iptraf-ng
    net-analyzer/mtr
    net-analyzer/netcat6
    net-analyzer/nmap
    net-analyzer/tcpdump
    net-analyzer/tcptraceroute
    net-analyzer/traceroute
    net-dns/bind-tools
    net-misc/keychain
    net-misc/telnet-bsd
    net-misc/whois
    sys-apps/ack
    sys-apps/dmidecode
    sys-apps/ethtool
    sys-apps/hdparm
    sys-apps/iproute2
    sys-apps/less
    sys-apps/lm_sensors
    sys-apps/lshw
    sys-apps/pciutils
    sys-fs/ncdu
    sys-power/acpitool
    sys-process/iotop
    sys-process/lsof
  )
end