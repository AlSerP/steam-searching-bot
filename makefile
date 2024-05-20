logs:
	docker compose logs -f bot

console:
	docker compose exec bot ruby bin/console.rb

bash:
	docker compose exec bot bash
