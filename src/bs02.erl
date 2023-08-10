-module(bs02).

-export([words/1]).

-include_lib("eunit/include/eunit.hrl").

words(Acc)-> words(Acc,[],<<>>).

words(<<" ",Rest/binary>>,Acc,L)-> words(<<Rest/binary>>,[L|Acc],<<>>);
words(<<H/utf8,Rest/binary>>,Acc,L)-> words(<<Rest/binary>>,Acc,<<L/binary,H/utf8>>);
words(<<>>,Acc,L)->lists:reverse([L|Acc]).

words_test_()->[
  words(<<"Some text and then something">>)=:=[<<"Some">>,<<"text">>,<<"and">>,<<"then">>,<<"something">>],
  words(<<"Some">>)=:=[<<"Some">>],
  words(<<>>)=:=[<<>>]
].