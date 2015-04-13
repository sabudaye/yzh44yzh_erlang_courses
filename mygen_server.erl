-module(mygen_server).

-export([start/0, server/1, add_user/2, remove_user/2, stop/1,
        get_users/1, get_users_count/1, crash/1]).

add_user(Pid, User) ->
  Pid ! {add_user, User}.

remove_user(Pid, User) ->
  Pid ! {remove_user, User}.

get_users(Pid) ->
  call(Pid, get_users).

get_users_count(Pid) ->
  call(Pid, get_users_count).

stop(Pid) ->
  Pid ! stop.

crash(Pid) ->
  call(Pid, crash).

call(Pid, Msg) ->
  Monitor = erlang:monitor(process, Pid),
  Pid ! {Msg, self(), Monitor},
  receive
    {reply, Monitor, Reply} ->
        erlang:demonitor(Monitor, [flush]),
        Reply;
    {'DOWN', Monitor, _, _, ErrorReason} ->
        {error, ErrorReason}
  after 1000 ->
    erlang:demonitor(Monitor, [flush]),
    no_reply
  end.

start() ->
  io:format("starting server from~p~n", [self()]),
  InitialState = [],
  spawn(mygen_server, server, [InitialState]).

server(State) ->
  io:format("I am server ~p~n", [self()]),
  receive
    {add_user, User} -> NewState = [User | State],
                        ?MODULE:server(NewState);
    {get_users, From, Ref} ->
                  From ! {reply, Ref, State},
                  ?MODULE:server(State);
    {get_users_count, From, Ref} ->
                  From ! {reply, Ref, length(State)},
                  ?MODULE:server(State);
    {remove_user, User} ->
                  NewState = lists:delete(User, State),
                  ?MODULE:server(NewState);
    {crash, _From, _Ref} -> io:format("I am going to crash :(~n"),
              A = 500,
              B = 0,
              A / B,
              ?MODULE:server(State);
    stop -> io:format("server ~p is stopping~n", [self()]);
    Msg -> io:format("server ~p got message ~p~n",
                                    [self(), Msg]),
          ?MODULE:server(State)
  end.
