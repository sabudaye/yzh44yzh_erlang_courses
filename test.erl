-module(test).

-export([init/0, filter_female/1,
        get_names/1, split_by_age/2, get_female_names/1, get_stat/1]).

init() ->
    [{user, 1, "Bob", male, 56},
     {user, 2, "Helen", female, 15},
     {user, 3, "Bill", male, 21},
     {user, 4, "Kate", female, 34}].

filter_female(Users) ->
   filter_female(Users, []).

filter_female([], Acc) -> lists:reverse(Acc);
filter_female([{user, _, _, Gender, _} | Rest], Acc)
    when Gender =:= male andalso Age > 12 orselse Id < 10 ->
        filter_female(Rest, Acc);
filter_female([{user, _, _, Gender, _} = User | Rest], Acc)
    when Gender =:= female ->
        filter_female(Rest, [User | Acc]).

get_names(Users) ->
    get_names(Users, []).

get_names([], Acc) -> Acc;
get_names([User | Rest], Acc) ->
    {user, _, Name, _, _} = User,
    get_names(Rest, [Name | Acc]).

% split_by_age(Users, Age) ->
%     split_by_age(Users, Age, {[], []}).
%
% split_by_age([], _Age, Acc) -> Acc;
% split_by_age([User | Rest], Age, {L1, L2}) ->
%     {user, _, _, _, UserAge} = User,
%     if
%         UserAge > Age ->
%             split_by_age(Rest, Age, {L1, [User | L2]});
%         true ->
%             split_by_age(Rest, Age, {[User | L1], L2})
%     end.

split_by_age(Users, Age) ->
    Acc = {[], []},
    F = fun(User, {First, Second}) ->
        {user, _Id, _Name, _Gender, UserAge} = User,
        if
            UserAge > Age ->
                {[User | First], Second};
            true ->
              {First, [User | Second]}
        end
      end,
    lists:foldl(F, Acc, Users).



get_female_names(Users) ->
    F = fun({user, _Id, Name, Gender, _Age}) ->
              if
                  Gender =:= male -> false;
                  true -> {true, Name}
              end
        end,
    lists:filtermap(F, Users).

get_stat(Users) ->
    Stat0 = {0, 0, 0, 0.0},
    F = fun(User, Acc) ->
          {user, _Id, Name, Gender, Age} = User,
          {TotalUsers, TotalMale, TotalFemale, TotalAge} = Acc,
          {TotalMale2, TotalFemale2} =
              case Gender of
                  male -> {TotalMale + 1, TotalFemale};
                  female -> {TotalMale, TotalFemale + 1}
              end,
          {TotalUsers + 1, TotalMale2, TotalFemale2, TotalAge + Age}
        end,
    {TU, TM, TF, TA} = lists:foldl(F, Stat0, Users),
    {TU, TM, TF, TA / TU}.
