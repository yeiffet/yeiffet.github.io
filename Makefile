start:
	docker-compose up -d
stop:
	docker-compose stop
remove:
	docker-compose down -v
build:
	docker run --rm --volume="$PWD:/srv/jekyll" -it jekyll/jekyll:latest jekyll build
init:
	docker run --rm --volume="$PWD:/srv/jekyll" -it jekyll/jekyll:latest bundle install --path vendor/bundle
	docker run --rm --volume="$PWD:/srv/jekyll" -it jekyll/jekyll:latest bundle add webrick
serve:
	docker run --rm --volume="$PWD:/srv/jekyll" -it -p 8080:4000 jekyll/jekyll:latest bundle exec jekyll serve --host 0.0.0.0
serve2:
	docker run --rm --volume="$PWD:/srv/jekyll" -p 8080:4000 -it jekyll/jekyll:latest jekyll serve --watch --drafts