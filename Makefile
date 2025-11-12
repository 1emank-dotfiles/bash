root ?= $(shell IFS=# read -r pre post < watchlist; echo "$$post" )

tree:
	@tree data -aC

deps:
	@command -v rsync >/dev/null 2>&1 && \
		echo "Dependencies (as in programs installed) satisfied."

valid_root: watchlist
	@case "$(root)" in //*) false;; esac
	@[ -d "$(root)" ]

repo: deps valid_root
	@while read -r file; do \
		if [ -d "$(root)/$$file/" ]; then \
			rsync -v "$(root)/$$file/" "./data/$$file/" \
				--delete --recursive --mkpath; \
		elif [ -f "$(root)/$$file" ]; then \
			rsync -v "$(root)/$$file" "./data/$$file" --mkpath; \
		fi \
	done < watchlist

target: deps valid_root
	@while read -r file; do \
		if [ -d "./data/$$file/" ]; then \
			rsync -v "./data/$$file/" "$(root)/$$file/"\
				--delete --recursive --mkpath; \
		elif [ -f "./data/$$file" ]; then \
			rsync -v "./data/$$file" "$(root)/$$file" --mkpath; \
		fi \
	done < watchlist
