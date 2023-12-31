-module(bs03).

-export([split/2]).

split(Acc,Sign)->split(Acc,Sign,Sign,<<>>,[]).

split(<<>>,_SplitSign,_TempSplitSign,TempAcc,Acc)->lists:reverse([<<TempAcc/binary>>|Acc]);
split(<<H/utf8>>,SplitSign,SplitSign,TempAcc,Acc)->lists:reverse([<<TempAcc/binary,H/utf8>>|Acc]);
split(<<_H/utf8,_M/utf8,_Rest/binary>>=X,SplitSign,[],TempAcc,Acc)->split(X,SplitSign,SplitSign,<<>>,[<<TempAcc/binary>>|Acc]);
split(<<H/utf8,Rest/binary>>,SplitSign,[HeadSplitSign|TailSplitSign],TempAcc,Acc)->
  case H == HeadSplitSign of
    true ->
      split(<<Rest/binary>>,SplitSign,TailSplitSign,TempAcc,Acc);
    false ->
      split(<<Rest/binary>>,SplitSign,SplitSign,<<TempAcc/binary,H/utf8>>,Acc)
  end.