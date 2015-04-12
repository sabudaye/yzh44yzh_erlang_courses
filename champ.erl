-module(champ).

-export([init/0, filter/1]).

init() ->
  [
    {team, "Cool Bools",
      [{player, "Bill", 35}, {player, "Bob", 24},
       {player, "BB", 15},{player, "TT", 40}]},
    {team, "Good Gays",
      [{player, "dBill", 11}, {player, "dBob", 22},
     {player, "dBB", 3},{player, "dTT", 44}]},
    {team, "Grazy Frogs",
      [{player, "cBill", 20}, {player, "cBob", 8},
     {player, "cBB", 5},{player, "cTT", 4}]},
    {team, "Mighty Dogs",
      [{player, "dBill", 40}, {player, "tBob", 50},
     {player, "eBB", 65},{player, "eTT", 55}]}
  ].


filter(Champ) ->
  MinMight = 10,
  MinPlayers = 3,
  FilterPlayers = fun({player, _Name, Might}) ->
        Might > MinMight
      end,
  FilterTeams = fun({team, _TeamName, Players}) ->
        length(lists:filter(FilterPlayers, Players)) > MinPlayers
      end,
  lists:filter(FilterTeams, Champ).
