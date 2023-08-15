-module(bs04_test).

-include_lib("eunit/include/eunit.hrl").

decode_test_()->[
  %1 Со всеми вложениями
  bs04:decode(<<"{'squadAge': 26,'members': [{'name': 'Molecule Man','age': '40','powers': ['Radiation resistance',
  'Mcdonalds',40,55]},{'name': 'Madame Uppercut','age': 39,'secretIdentity': 'Jane Wilson','powers':
  ['Million tonne punch','Damage resistance','Superhuman reflexes'],'name': 'Danyil'}]}">>)=:=[{<<"squadAge">>,
  <<"26">>},{<<"members">>,[[{<<"name">>,<<"Molecule Man">>},{<<"age">>,<<"40">>},{<<"powers">>,[<<"Radiation
  resistance">>,<<"Mcdonalds">>,<<"40">>,<<"55">>]}],[{<<"name">>,<<"Madame Uppercut">>},{<<"age">>,<<"39">>},
  {<<"secretIdentity">>,<<"Jane Wilson">>},{<<"powers">>,[<<"Superhuman reflexes">>,<<"Damage resistance">>,
  <<"Million tonne punch">>]},{<<"name">>,<<"Danyil">>}]]}],
  %2 Без вложений
  bs04:decode(<<"{'squadName': 'Super hero squad','homeTown': 'Metro City','formed': 2016,'secretBase': 'Super tower',
  'active': true}">>)=:=[{<<"squadName">>,<<"Super hero squad">>},{<<"homeTown">>,<<"Metro City">>},{<<"formed">>,
  <<"2016">>},{<<"secretBase">>,<<"Super tower">>},{<<"active">>,<<"true">>}],
  %3 Без листов в Members
  bs04:decode(<<"{'active': true,'members': [{'name': 'Molecule Man','age': 29,'secretIdentity': 'Dan Jukes'},
  {'name': 'Madame Uppercut','age': 39,'secretIdentity': 'Jane Wilson'},{'name': 'Eternal Flame',
  'age': 1000000,'secretIdentity': 'Unknown'}]}">>)=:=[{<<"active">>,<<"true">>},{<<"members">>,[[{<<"name">>,
  <<"Molecule Man">>},{<<"age">>,<<"29">>},{<<"secretIdentity">>,<<"Dan Jukes">>}],[{<<"name">>,<<"Madame Uppercut">>},
  {<<"age">>,<<"39">>},{<<"secretIdentity">>,<<"Jane Wilson">>}],[{<<"name">>,<<"Eternal Flame">>},{<<"age">>,<<"1000000">>},
  {<<"secretIdentity">>,<<"Unknown">>}]]}],
  %4 Ничего
  bs04:decode(<<>>) =:= [],
  %5 С одной записью, где значение НЕ в ковычках
  bs04:decode(<<"{'name': 25}">>) =:= [{<<"name">>,<<"25">>}],
  % С одной записью, где значение в ковычках
  bs04:decode(<<"{'name': '25'}">>) =:= [{<<"name">>,<<"25">>}]
].