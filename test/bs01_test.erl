-module(bs01_test).

-include_lib("eunit/include/eunit.hrl").

first_word_test_()->[
  bs01:first_word(<<"Some text">>)=:=<<"Some">>,
  bs01:first_word(<<"Some">>)=:=<<"Some">>,
  bs01:first_word(<<>>)=:=<<>>
].