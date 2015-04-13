-module(mygen_server).

-export([start/0]).

start() ->
  io:format("starting server~n"),
  spawn(fun server/0).

server() ->
  io:format("I am server ~p~n", [self()]),
  ok.
