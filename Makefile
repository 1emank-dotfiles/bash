root ?= $(shell IFS=# read -r pre post < watchlist; echo "$$post" )

tree:
	@tree data -aC

deps:
	@sh/deps.sh rsync

valid_root: watchlist
	@sh/valid_root.sh "$(root)"

repo: deps valid_root
	#
	# Copying from `$(root)/` to `data/`
	#
	@sh/repo.sh "$(root)"

backup: deps valid_root
	#
	# Copying from `$(root)/` to `backup/`
	#
	@sh/backup.sh "$(root)"

recover: deps valid_root
	#
	# Copying from `backup/` to `$(root)/`
	#
	@sh/recover.sh "$(root)"

deploy: deps valid_root
	#
	# Copying from `data/` to `$(root)/`
	#
	@sh/deploy.sh "$(root)"

install: backup deploy
