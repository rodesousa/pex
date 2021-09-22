postgres_run:
	@docker run -it -d --name pex_db -p 5432:5432 -e POSTGRES_USER=user -e POSTGRES_PASSWORD=dev postgres

postgres_start:
	@docker start pex_db

postgres_rm:
	@docker rm -f pex_db
