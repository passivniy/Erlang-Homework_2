-module(bs01).

-export([first_word/1]).

-include_lib("eunit/include/eunit.hrl").

first_word(Acc)->first_word(Acc,<<>>).

first_word(<<" ",_Rest/binary>>,Acc)->Acc;
first_word(<<H/utf8,M/utf8,Rest/binary>>,Acc)->first_word(<<M/utf8,Rest/binary>>,<<Acc/binary,H/utf8>>);
first_word(<<H>>,Acc)-><<Acc/binary,H/utf8>>;
first_word(<<>>,Acc)->Acc.

first_word_test_()->[
  first_word(<<"Some text">>)=:=<<"Some">>,
  first_word(<<"Some">>)=:=<<"Some">>,
  first_word(<<>>)=:=<<>>
].