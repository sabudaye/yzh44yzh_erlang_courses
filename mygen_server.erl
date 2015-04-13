-module(mygen_server).

-export([start/0, server/1, add_user/2, remove_user/2, stop/1, get_users/1]).

add_user(Pid, User) ->
  Pid ! {add_user, User}.

remove_user(Pid, User) ->
  Pid ! {remove_user, User}.

get_users(Pid) ->
    Ref = make_ref(),
    Pid ! [get_users, self(), Ref],
    receive
      {reply, Ref, Users} -> Users,
    after 500 -> no_reply  
    end.

stop(Pid) ->
  Pid ! stop.

start() ->
  io:format("starting server from~p~n", [self()]),
  InitialState = [],
  spawn(mygen_server, server, [InitialState]).

server(State) ->
  io:format("I am server ~p~n", [self()]),
  receive
    {add_user, User} -> NewState = [User | State],
                        ?MODULE:server(NewState);
    [get_users, From, Ref] ->
                  From ! {reply, Ref, State},
                  ?MODULE:server(State);
    {remove_user, User} ->
                  NewState = lists:delete(User, State),
                  ?MODULE:server(NewState);
    stop -> io:format("server ~p is stopping~n", [self()]);
    Msg -> io:format("server ~p got message ~p~n",
                                    [self(), Msg]),
          ?MODULE:server(State)
  end.
