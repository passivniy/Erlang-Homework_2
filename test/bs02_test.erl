-module(bs02_test).

-include_lib("eunit/include/eunit.hrl").

words_test_()->[
  bs02:words(<<"Some text and then something">>)=:=[<<"Some">>,<<"text">>,<<"and">>,<<"then">>,<<"something">>],
  bs02:words(<<"Some">>)=:=[<<"Some">>],
  bs02:words(<<>>)=:=[<<>>]
].