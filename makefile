logs:
	cat -f logs/main.log

console:
	docker compose exec bot ruby bin/console.rb

bash:
	docker compose exec bot bash
