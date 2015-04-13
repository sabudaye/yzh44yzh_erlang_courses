-module(mygen_server).

-export([start/0, server/1, add_user/2, remove_user/2, stop/1, show_users/1]).

add_user(Pid, User) ->
  Pid ! {add_user, User}.

remove_user(Pid, User) ->
  Pid ! {remove_user, User}.

stop(Pid) ->
  Pid ! stop.

show_users(Pid) ->
  Pid ! show_users.

start() ->
  io:format("starting server Ver. 4 from~p~n", [self()]),
  InitialState = [],
  spawn(mygen_server, server, [InitialState]).

server(State) ->
  io:format("I am server  Ver. 4 ~p~n", [self()]),
  receive
    {add_user, User} -> NewState = [User | State],
                        ?MODULE:server(NewState);
    show_users -> io:format("users are ~p~n", [State]),
                  ?MODULE:server(State);
    {remove_user, User} ->
                  NewState = lists:delete(User, State),
                  ?MODULE:server(NewState);
    stop -> io:format("server ~p is stopping~n", [self()]);
    Msg -> io:format("server ~p got message ~p~n",
                                    [self(), Msg]),
          ?MODULE:server(State)
  end.
