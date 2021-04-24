.SILENT:
.PHONY: server-static

FILES = src/nicolas_dot_martinussen_dot_eu.cr src/index.ecr src/language-chooser.ecr
ALL_FILES = public/css/style.min.css public/js/bundle.js $(FILES)

ALL: server public/css/style.min.css public/js/bundle.js

public/css/style.min.css: scss/style.scss $(wildcard scss/src/*.scss)
	echo "Création de css/style.min.css"
	cd ./scss/ && \
	sass --no-source-map --style=compressed style.scss:../public/css/style.min.css
	
public/js/bundle.js: js/src/main.js
	echo "Création de js/bundle.js"
	cd ./js/ && \
	rollup --config rollup.config.js

server: $(FILES)
	echo "Création de server"
	crystal build src/nicolas_dot_martinussen_dot_eu.cr -o server

server-static: $(ALL_FILES)
	echo "Création de server static"
	shards install --ignore-crystal-version
	crystal build src/nicolas_dot_martinussen_dot_eu.cr -o server --static