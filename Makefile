root ?= $(shell IFS=# read -r pre post < watchlist; echo "$$post" )

tree:
	@tree data -aC

deps:
	@missing=false; \
	dep() {\
		if ! command -v $$1 >/dev/null 2>&1; then \
			echo Missing dependency: $$1; \
			missing=true; \
		fi; \
	}; \
	dep rsync; \
	! $$missing

valid_root: watchlist
	@case "$(root)" in //*) false;; esac
	@[ -d "$(root)" ]

repo: deps valid_root
	#
	# Copying from `$(root)/` to `data/`
	#
	@while read -r file; do \
		if [ -d "$(root)/$$file/" ]; then \
			rsync -i "$(root)/$$file/" "./data/$$file/" \
				--delete --recursive --mkpath; \
		elif [ -f "$(root)/$$file" ]; then \
			rsync -i "$(root)/$$file" "./data/$$file" --mkpath; \
		fi \
	done < watchlist

backup: deps valid_root
	#
	# Copying from `$(root)/` to `backup/`
	#
	@while read -r file; do \
		if [ -d "$(root)/$$file/" ]; then \
			rsync -i "$(root)/$$file/" "./backup/$$file/" \
				--delete --recursive --mkpath; \
		elif [ -f "$(root)/$$file" ]; then \
			rsync -i "$(root)/$$file" "./backup/$$file" --mkpath; \
		fi \
	done < watchlist

recover: deps valid_root
	#
	# Copying from `backup/` to `$(root)/`
	#
	@while read -r file; do \
		if [ -d "./backup/$$file/" ]; then \
			rsync -i "./backup/$$file/" "$(root)/$$file/"\
				--delete --recursive --mkpath; \
		elif [ -f "./backup/$$file" ]; then \
			rsync -i "./backup/$$file" "$(root)/$$file" --mkpath; \
		fi \
	done < watchlist

deploy: deps valid_root
	#
	# Copying from `data/` to `$(root)/`
	#
	@while read -r file; do \
		if [ -d "./data/$$file/" ]; then \
			rsync -i "./data/$$file/" "$(root)/$$file/"\
				--delete --recursive --mkpath; \
		elif [ -f "./data/$$file" ]; then \
			rsync -i "./data/$$file" "$(root)/$$file" --mkpath; \
		fi \
	done < watchlist

install: backup deploy
