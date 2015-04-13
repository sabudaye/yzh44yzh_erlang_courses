-module(mygen_server).

-export([start/0, server/1]).

start() ->
  io:format("starting server Ver. 3 from~p~n", [self()]),
  InitialState = [],
  spawn(mygen_server, server, [InitialState]).

server(State) ->
  io:format("I am server  Ver. 3 ~p~n", [self()]),
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
