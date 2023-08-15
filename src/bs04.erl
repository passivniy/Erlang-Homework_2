-module(bs04).

%% API
-export([decode/1]).

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