start_interface:
	echo 1 > /proc/sys/net/ipv4/ip_forward
#	iptables -t nat -A POSTROUTING -s 172.30.0.0/24 -o enp3s0 -j MASQUERADE
	ip link add digitaltwin0 link enp3s0 type macvlan
	ip addr add 172.30.0.1/24 dev digitaltwin0
	ip link set digitaltwin0 up

remove_interface:
#	iptables -t nat -D POSTROUTING -s 172.30.0.0/24 -o enp3s0 -j MASQUERADE
	ip link delete digitaltwin0

up: #start_interface
#	ip link set enp3s0 promisc on
	docker compose up

upd: #start_interface
#	ip link set $(shell ip route | grep default | cut -d ' ' -f 5) promisc on
	docker compose up -d

down: #remove_interface
	docker compose down

stop:
	docker compose stop