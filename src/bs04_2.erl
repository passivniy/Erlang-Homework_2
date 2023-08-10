-module(bs04_2).

%% API
-export([decode/1]).

-include_lib("eunit/include/eunit.hrl").

decode(<<>>) -> [];
decode(Json) -> decode(Json,[]).

decode(<<"{",Rest/binary>>,Acc)->
  [Tail,Result] = decode_text(<<Rest/binary>>,<<>>,<<>>),
  decode(Tail,[Result|Acc]);
decode(<<"'",Rest/binary>>,Acc)->
  [Tail,Result]=decode_text(<<"'",Rest/binary>>,<<>>,<<>>),
  decode(Tail,[Result|Acc]);
decode(<<"}">>,Acc)->lists:reverse(Acc).

decode_text(<<"[{",Rest/binary>>,<<>>,SecondEl)->
  [Tail,Result] = decode_dict(<<Rest/binary>>,[],[]),
  [Tail,{SecondEl,lists:reverse(Result)}];
decode_text(<<"': ",Rest/binary>>,FirstEl,<<>>)->
  decode_text(<<Rest/binary>>,<<>>,FirstEl);
decode_text(<<"'",H/utf8,Rest/binary>>,<<>>,<<>>)->
  decode_text(<<Rest/binary>>,<<H/utf8>>,<<>>);
decode_text(<<"'",H/utf8,Rest/binary>>,<<>>,SecondEl)->
  decode_text(<<Rest/binary>>,<<H/utf8>>,SecondEl);
decode_text(<<"',",Rest/binary>>,FirstEl,SecondEl)->
  [<<Rest/binary>>,{SecondEl,FirstEl}];
decode_text(<<",",Rest/binary>>,FirstEl,SecondEl)->
  [<<Rest/binary>>,{SecondEl,FirstEl}];
decode_text(<<"'",Rest/binary>>,FirstEl,SecondEl)->
  [<<Rest/binary>>,{SecondEl,FirstEl}];
decode_text(<<H/utf8,Rest/binary>>,FirstEl,<<>>)->
  decode_text(<<Rest/binary>>,<<FirstEl/binary,H/utf8>>,<<>>);
decode_text(<<"[",Rest/binary>>,<<>>,SecondEl)->
  [Tail,Result] = decode_list(<<Rest/binary>>,<<>>,[]),
  [Tail,{SecondEl,Result}];
decode_text(<<H/utf8,Rest/binary>>,<<>>,SecondEl)->
  decode_text(<<Rest/binary>>,<<H/utf8>>,SecondEl);
decode_text(<<"}",Rest/binary>>,FirstEl,SecondEl)->
  [<<"}",Rest/binary>>,{SecondEl,FirstEl}];
decode_text(<<H/utf8,Rest/binary>>,FirstEl,SecondEl)->
  decode_text(<<Rest/binary>>,<<FirstEl/binary,H/utf8>>,SecondEl).

decode_dict(<<"'",Rest/binary>>,TempAcc,Acc)->
  [Total,Result] = decode_text(<<"'",Rest/binary>>,<<>>,<<>>),
  decode_dict(Total,[Result|TempAcc],Acc);
decode_dict(<<"},{",Rest/binary>>,TempAcc,Acc)->
  [Tail,Result] = decode_text(<<Rest/binary>>,<<>>,<<>>),
  decode_dict(Tail,[Result],[lists:reverse(TempAcc)|Acc]);
decode_dict(<<",",Rest/binary>>,TempAcc,Acc)->
  [Tail,Result] = decode_text(<<Rest/binary>>,<<>>,<<>>),
  decode_dict(Tail,[Result|TempAcc],Acc);
decode_dict(<<"}]",Rest/binary>>,TempAcc,Acc)->
  [<<Rest/binary>>,[lists:reverse(TempAcc)|Acc]].

decode_list(<<"'",H/utf8,Rest/binary>>,<<>>,Acc)->
  decode_list(<<Rest/binary>>,<<H/utf8>>,Acc);
decode_list(<<",",Rest/binary>>,Element,Acc)->
  decode_list(<<Rest/binary>>,<<>>,[Element|Acc]);
decode_list(<<"',",Rest/binary>>,Element,Acc)->
  decode_list(<<Rest/binary>>,<<>>,[Element|Acc]);
decode_list(<<"]",Rest/binary>>,Element,Acc)->
  [<<Rest/binary>>,lists:reverse([Element|Acc])];
decode_list(<<"']",Rest/binary>>,Element,Acc)->
  [<<Rest/binary>>,[Element|Acc]];
decode_list(<<H/utf8,Rest/binary>>,Element,Acc)->
  decode_list(<<Rest/binary>>,<<Element/binary,H/utf8>>,Acc).


decode_test_()->[
  %1 Со всеми вложениями
  decode(<<"{'squadAge': 26,'members': [{'name': 'Molecule Man','age': '40','powers': ['Radiation resistance',
  'Mcdonalds',40,55]},{'name': 'Madame Uppercut','age': 39,'secretIdentity': 'Jane Wilson','powers':
  ['Million tonne punch','Damage resistance','Superhuman reflexes'],'name': 'Danyil'}]}">>)=:=[{<<"squadAge">>,
  <<"26">>},{<<"members">>,[[{<<"name">>,<<"Molecule Man">>},{<<"age">>,<<"40">>},{<<"powers">>,[<<"Radiation
  resistance">>,<<"Mcdonalds">>,<<"40">>,<<"55">>]}],[{<<"name">>,<<"Madame Uppercut">>},{<<"age">>,<<"39">>},
  {<<"secretIdentity">>,<<"Jane Wilson">>},{<<"powers">>,[<<"Superhuman reflexes">>,<<"Damage resistance">>,
  <<"Million tonne punch">>]},{<<"name">>,<<"Danyil">>}]]}],
  %2 Без вложений
  decode(<<"{'squadName': 'Super hero squad','homeTown': 'Metro City','formed': 2016,'secretBase': 'Super tower',
  'active': true}">>)=:=[{<<"squadName">>,<<"Super hero squad">>},{<<"homeTown">>,<<"Metro City">>},{<<"formed">>,
  <<"2016">>},{<<"secretBase">>,<<"Super tower">>},{<<"active">>,<<"true">>}],
  %3 Без листов в Members
  decode(<<"{'active': true,'members': [{'name': 'Molecule Man','age': 29,'secretIdentity': 'Dan Jukes'},
  {'name': 'Madame Uppercut','age': 39,'secretIdentity': 'Jane Wilson'},{'name': 'Eternal Flame',
  'age': 1000000,'secretIdentity': 'Unknown'}]}">>)=:=[{<<"active">>,<<"true">>},{<<"members">>,[[{<<"name">>,
  <<"Molecule Man">>},{<<"age">>,<<"29">>},{<<"secretIdentity">>,<<"Dan Jukes">>}],[{<<"name">>,<<"Madame Uppercut">>},
  {<<"age">>,<<"39">>},{<<"secretIdentity">>,<<"Jane Wilson">>}],[{<<"name">>,<<"Eternal Flame">>},{<<"age">>,<<"1000000">>},
  {<<"secretIdentity">>,<<"Unknown">>}]]}],
  %4 Ничего
  decode(<<>>) =:= [],
  %5 С одной записью, где значение НЕ в ковычках
  decode(<<"{'name': 25}">>) =:= [{<<"name">>,<<"25">>}],
  % С одной записью, где значение в ковычках
  decode(<<"{'name': '25'}">>) =:= [{<<"name">>,<<"25">>}]
].