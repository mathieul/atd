MOCHA=./node_modules/.bin/mocha
FLAGS=--compilers coffee:coffee-script --recursive --timeout 1s
export NODE_PATH := ${PWD}/app:${NODE_PATH}

test:
	@${MOCHA} ${FLAGS}

watch:
	@${MOCHA} ${FLAGS} -w -G

console:
	@coffee

.PHONY: test