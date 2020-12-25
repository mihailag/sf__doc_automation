# Makefile
SITE=https://www.chiark.greenend.org.uk/~sgtatham/bugs-ru.html
IMAGE=sf_doc

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

sync:
	wget --mirror -p --convert-links -nd -P mirror_doc $(SITE) || true

deploy: sync
	docker build -t $(IMAGE) .
	docker save $(IMAGE) | bzip2 | ssh $(USER)@$(IP) 'bunzip2 | docker load'
	ssh $(USER)@$(IP) 'docker run -d -p 80:80 $(IMAGE)'

schedule:
	crontab -l > cron.tmp || touch cron.tmp
	echo "45 3 * * 6 wget --mirror -p --convert-links -nd -P $(CURDIR)/mirror_doc $(SITE)" >> cron.tmp
	crontab cron.tmp
	rm cron.tmp

initial:
	ssh $(USER)@$(IP) 'wget -O - https://get.docker.com/ | bash - && sudo usermod -aG docker $(USER)'