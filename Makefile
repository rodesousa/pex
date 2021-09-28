CMD = @docker run -d -it --name pex_db
CMD += -p 5432:5432
CMD += -v pex_data:/var/lib/postgresql/data
CMD += -e POSTGRES_USER=user
CMD += -e POSTGRES_PASSWORD=dev
CMD += postgres

db:
	${CMD}

db_rm:
	@docker rm -f pex_db

volume_rm:
	@docker volume rm pex_data
