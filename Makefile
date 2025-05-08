start_interface:
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A POSTROUTING -s 172.30.0.0/24 -o enp3s0 -j MASQUERADE
	iptables -A FORWARD -i enp3s0 -o digitaltwin0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -i digitaltwin0 -o enp3s0 -j ACCEPT
	ip link add digitaltwin0 link enp3s0 type ipvlan mode l3
	ip addr add 172.30.0.1/24 dev digitaltwin0
	ip link set digitaltwin0 up

remove_interface:
	iptables -t nat -D POSTROUTING -s 172.30.0.0/24 -o enp3s0 -j MASQUERADE
	iptables -D FORWARD -i enp3s0 -o digitaltwin0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -D FORWARD -i digitaltwin0 -o enp3s0 -j ACCEPT
	ip link delete digitaltwin0

up: start_interface
	docker compose up

upd: start_interface
	docker compose up -d

down: remove_interface
	docker compose down

stop:
	docker compose stop