.SILENT:
.PHONY: scss rollup server-static

FILES = src/nicolas_dot_martinussen_dot_eu.cr src/index.ecr src/language-chooser.ecr

ALL: server scss rollup 

scss: scss/style.scss $(wildcard scss/src/*.scss)
	echo "Création de css/style.min.css"
	cd ./scss/ && \
	sass --no-source-map --style=compressed style.scss:../public/css/style.min.css
	
rollup: js/src/main.js
	echo "Création de js/bundle.js"
	cd ./js/ && \
	rollup --config rollup.config.js

server: $(FILES)
	echo "Création de server"
	crystal build src/nicolas_dot_martinussen_dot_eu.cr -o server

server-static: scss rollup $(FILES)
	echo "Création de server static"
	shards install --ignore-crystal-version
	crystal build src/nicolas_dot_martinussen_dot_eu.cr -o server --static