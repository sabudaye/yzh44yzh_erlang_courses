compile:
	erlc *.erl

run:
	erl \
	-pa ~/Documents/cowboy/ebin \
	-pa ~/Documents/cowboy/deps/*/ebin \
	-s try_cowboy start

clean:
	-rm *.beam
