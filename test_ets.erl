-module(test_ets).

-export([init/0]).

init() ->
  T = ets:new(my_ets, [{keypos, 2}]),
  ets:insert(T, {usesr, 1, "Bob", 12}),
  ets:insert(T, {usesr, 2, "Bill", 21}),
  ets:insert(T, {usesr, 3, "David", 22}),
  ets:insert(T, {usesr, 4, "Kate", 33}),
  ets:insert(T, {usesr, 5, "Helen", 18}),
  T.
