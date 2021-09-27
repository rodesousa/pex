CMD = @docker run -d --name arkhn_livebook
CMD += -p 8080:8080 --pull always -u $(id -u):$(id -g)
CMD += -v data:/data
CMD += -v /var/run/docker.sock:/var/run/docker.sock 
CMD += -e BINANCE_API_KEY=${BINANCE_API_KEY}
CMD += -e BINANCE_SECRET_KEY=${BINANCE_SECRET_KEY}
CMD += -e KUCOIN_API_KEY=${KUCOIN_API_KEY}
CMD += -e KUCOIN_API_SECRET=${KUCOIN_API_SECRET}
CMD += -e KUCOIN_API_PASSPHRASE=${KUCOIN_API_PASSPHRASE}
CMD += livebook/livebook

run:
	${CMD}

start:
	@docker start arkhn_livebook

delete:
	@docker rm -f arkhn_livebook

logs:
	@docker logs arkhn_livebook
