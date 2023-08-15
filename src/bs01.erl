-module(bs01).

-export([first_word/1]).

first_word(Acc)->first_word(Acc,<<>>).

first_word(<<" ",_Rest/binary>>,Acc)->Acc;
first_word(<<H/utf8,M/utf8,Rest/binary>>,Acc)->first_word(<<M/utf8,Rest/binary>>,<<Acc/binary,H/utf8>>);
first_word(<<H>>,Acc)-><<Acc/binary,H/utf8>>;
first_word(<<>>,Acc)->Acc.