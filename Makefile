MOCHA=./node_modules/.bin/mocha
FLAGS=--compilers coffee:coffee-script

test:
	@${MOCHA} ${FLAGS}

watch:
	@${MOCHA} ${FLAGS} -w

.PHONY: test