up:
	docker compose up

upd: 
	docker compose up -d

down:
	docker compose down

stop:
	docker compose stop

restart-firewall:
	docker compose exec router fw3 restart