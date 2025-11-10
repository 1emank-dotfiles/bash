root ?= $(HOME)

tree:
	@tree data -aC

deps:
	@command -v rsync >/dev/null 2>&1

repo: deps watchfiles
	@while read -r file; do \
		if [ -d "$(root)/$$file/" ]; then \
			rsync -v "$(root)/$$file/" "./data/$$file/" --delete --recursive --mkpath; \
		elif [ -f "$(root)/$$file" ]; then \
			rsync -v "$(root)/$$file" "./data/$$file" --mkpath; \
		fi \
	done < watchfiles

home: deps watchfiles
	@while read -r file; do \
		if [ -d "./data/$$file/" ]; then \
			rsync -v "./data/$$file/" "$(root)/$$file/" --delete --recursive --mkpath; \
		elif [ -f "./data/$$file" ]; then \
			rsync -v "./data/$$file" "$(root)/$$file" --mkpath; \
		fi \
	done < watchfiles
