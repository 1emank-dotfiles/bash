deps:
	@command -v rsync >/dev/null 2>&1

repo: deps watchfiles
	@while read -r file; do \
		if [ -d "$$HOME/$$file/" ]; then \
			rsync -v "$$HOME/$$file/" "./home/$$file/" --delete --recursive --mkpath; \
		elif [ -f "$$HOME/$$file" ]; then \
			rsync -v "$$HOME/$$file" "./home/$$file" --mkpath; \
		fi \
	done < watchfiles

home: deps watchfiles
	@while read -r file; do \
		if [ -d "./home/$$file/" ]; then \
			rsync -v "./home/$$file/" "$$HOME/$$file/" --delete --recursive --mkpath; \
		elif [ -f "./home/$$file" ]; then \
			rsync -v "./home/$$file" "$$HOME/$$file" --mkpath; \
		fi \
	done < watchfiles
