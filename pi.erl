-module(pi).
-export([calculate/3, pi/1]).

calculate(To, To, H) ->
	X = (To - 0.5) * H,
	(4.0/(1.0 + X * X));

calculate(From, To, H) ->
	X = (From - 0.5) * H,
	(4.0/(1.0 + X * X)) + calculate(From + 1, To, H).

pi(To) ->
	H = 1/To,
	calculate(1, To, H) * H.
