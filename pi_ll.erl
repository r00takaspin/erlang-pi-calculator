-module(pi_ll).
-export([pi/1]).

calculate(To, To, H) ->
	X = (To - 0.5) * H,
	(4.0/(1.0 + X * X));

calculate(From, To, H) ->
	X = (From - 0.5) * H,
	(4.0/(1.0 + X * X)) + calculate(From + 1, To, H).

from(Number, Delta) ->
	if
		Number == 1 -> 1;
		true -> (Number-1) * Delta + 1
	end.

to(Number, Delta) ->
	if
		Number == 1 -> Delta;
		true -> Delta * Number
	end.

pi(To)->
	Self = self(),
	Cores = erlang:system_info(schedulers_online),
	{Step, Delta} = {1/To, round(To / Cores)},
	Pids = lists:map(fun (El) ->
		spawn(fun()->
			Self ! {sum, calculate(from(El, Delta), to(El, Delta), Step)}
		end)
	end, lists:seq(1, Cores)),
	lists:sum([receive {sum, S} -> S end || _ <- Pids ]) * Step.
