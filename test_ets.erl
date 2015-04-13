-module(test_ets).

-export([init/0, test_select/0, select/1]).

-include_lib("stdlib/include/ms_transform.hrl").

init() ->
  T = ets:new(my_ets, [{keypos, 2}, named_table]),
  ets:insert(T, {usesr, 1, "Bob", 12}),
  ets:insert(T, {usesr, 2, "Bill", 21}),
  ets:insert(T, {usesr, 3, "David", 22}),
  ets:insert(T, {usesr, 4, "Kate", 33}),
  ets:insert(T, {usesr, 5, "Helen", 18}),
  T.

test_select() ->
  Pattern = ets:fun2ms(
      fun({usesr, Id, Name, Age})
        when Age > 20 ->
          {Id, Name}
      end),
  Pattern.

select(Pattern) ->
  ets:select(my_ets, Pattern).
