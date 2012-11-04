MOCHA=./node_modules/.bin/mocha
FLAGS=--compilers coffee:coffee-script
export NODE_PATH := ./app:${NODE_PATH}

test:
	@${MOCHA} ${FLAGS}

watch:
	@${MOCHA} ${FLAGS} -w -G

.PHONY: test