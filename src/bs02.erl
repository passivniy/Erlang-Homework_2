-module(bs02).

-export([words/1]).

words(Acc)-> words(Acc,[],<<>>).

words(<<" ",Rest/binary>>,Acc,L)-> words(<<Rest/binary>>,[L|Acc],<<>>);
words(<<H/utf8,Rest/binary>>,Acc,L)-> words(<<Rest/binary>>,Acc,<<L/binary,H/utf8>>);
words(<<>>,Acc,L)->lists:reverse([L|Acc]).
