-module(bs03_test).

-include_lib("eunit/include/eunit.hrl").

split_test_()->[
  bs03:split(<<"Bit1-:-Bit2-:-Bit3-:-Bit4">>,"-:-")=:=[<<"Bit1">>,<<"Bit2">>,<<"Bit3">>,<<"Bit4">>],
  bs03:split(<<"Bit1-:-Bit2">>,"-:-")=:=[<<"Bit1">>,<<"Bit2">>],
  bs03:split(<<"Bit1+Bit2+Bit3+Bit4">>,"+")=:=[<<"Bit1">>,<<"Bit2">>,<<"Bit3">>,<<"Bit4">>],
  bs03:split(<<>>,"-")=:=[<<>>]
].