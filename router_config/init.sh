#!/bin/sh

test -e /.started && exit 0

uci -q batch <<-EOF >/dev/null
  delete network.lan
  delete network.wan
  delete network.wan6

  # internet interface
  set network.internet=interface
  set network.internet.proto=static
  set network.internet.ifname=eth0
  set network.internet.ipaddr='172.30.0.2'
  set network.internet.dns='8.8.8.8 8.8.4.4'
  set network.internet.gateway='172.30.0.1'
  set network.internet.netmask='255.255.255.0'

  # office interface
  set network.office=interface
  set network.office.proto=static
  set network.office.ifname=eth1
  set network.office.ipaddr='172.29.0.1'
  set network.office.dns='8.8.8.8 8.8.4.4'
  set network.office.netmask='255.255.255.0'

  # factory interface
  set network.factory=interface
  set network.factory.proto=static
  set network.factory.ifname=eth2
  set network.factory.ipaddr='172.28.0.1'
  set network.factory.dns='8.8.8.8 8.8.4.4'
  set network.factory.netmask='255.255.255.0'

  set network.loopback.ipaddr='127.0.0.1'
  set network.loopback.netmask='255.0.0.0'

  commit network

  set uhttpd.main.rfc1918_filter=0
  commit uhttpd
EOF

# remove old wan/lan rules (add this part if you require removing default zones and rules)
n=$(uci show firewall | egrep "wan|lan" | wc -l)
for i in $(seq 1 $n)
do
 uci delete $(uci show firewall | egrep "wan|lan" | head -1 | cut -d. -f1,2)
done 

uci commit

uci -q batch <<-EOF >/dev/null
  set firewall.@include[0].reload='1'
  
  add firewall zone   
  set firewall.@zone[-1]=zone
  set firewall.@zone[-1].name='internet'
  set firewall.@zone[-1].network='internet'
  set firewall.@zone[-1].input='ACCEPT'
  set firewall.@zone[-1].output='ACCEPT'
  set firewall.@zone[-1].forward='ACCEPT'
  set firewall.@zone[-1].masq='1'
  commit firewall.@zone[-1]

  add firewall zone
  set firewall.@zone[-1]=zone
  set firewall.@zone[-1].name='office'
  set firewall.@zone[-1].network='office'
  set firewall.@zone[-1].input='ACCEPT'
  set firewall.@zone[-1].output='ACCEPT'
  set firewall.@zone[-1].forward='ACCEPT'
  commit firewall.@zone[-1]

  add firewall zone
  set firewall.@zone[-1]=zone
  set firewall.@zone[-1].name='factory'
  set firewall.@zone[-1].network='factory'
  set firewall.@zone[-1].input='ACCEPT'
  set firewall.@zone[-1].output='ACCEPT'
  set firewall.@zone[-1].forward='ACCEPT'
  commit firewall.@zone[-1]

  # Forwarding between zones
  add firewall forwarding
  set firewall.@forwarding[-1].src='office'
  set firewall.@forwarding[-1].dest='internet'

  # Forwarding between zones
  add firewall forwarding
  set firewall.@forwarding[-1].src='factory'
  set firewall.@forwarding[-1].dest='internet'

  # NAT
  add firewall nat
  set firewall.@nat[-1].target='MASQUERADE'
  set firewall.@nat[-1].name='NAT'
  set firewall.@nat[-1].device='eth0'
  set firewall.@nat[-1].src='internet'
  set firewall.@nat[-1].proto='all'

  commit firewall
EOF

touch /.started

exit 0


