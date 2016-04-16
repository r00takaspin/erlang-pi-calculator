-module(pi).
-export([calculate/3, pi/2,start/0]).

calculate(To, To, H) ->
	X = (To - 0.5) * H,
	(4.0/(1.0 + X * X));

calculate(From, To, H) ->
	X = (From - 0.5) * H,
	(4.0/(1.0 + X * X)) + calculate(From + 1, To, H).

pi(From, To) ->
	H = 1/To,
	calculate(From, To, H) * H.

start()->
	io:format("Format ~p~n",[pi:calculate(1,100000000,1/100000000)*1/100000000]),
	erlang:halt().
