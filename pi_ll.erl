-module(pi_ll).
-export([start/1]).

% x(To, H)->
% 	(To - 0.5) * H.

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

sum([]) -> 0;
sum([H|Tail])-> H + sum(Tail).

calculation(Pid, From, To, H) ->
	receive
		{calc} ->
			io:format("*We are calculating ~w ~w ~w ~n",[From, To, H]),
			io:format("Sending back message to {pi} ~w~n",[Pid]),
			Pid ! {pi, calculate(From, To, H)};
		Other->
			io:format("Unknown message ~w ~n", [Other])
	end.

aggregate_calculations(S) ->
	receive
		{send_messages, Pids} ->
			lists:foreach(fun(Pid) ->
				io:format("We are sending message to PID: ~w~n", [Pid]),
				Pid ! {calc}
			end, Pids),
			aggregate_calculations(S);
		{pi, Number} ->
			io:format("pi message: ~w~n",[Number]),
			S ! {sum, Number},
			aggregate_calculations(S);
		Other ->
			io:format("!!!!Unknown command ~w~n",[Other])
	end.

start(To)->
	S = self(),
	% получаем число процессоров в системе
	Cores = erlang:system_info(schedulers_online),
	{Step, Delta} = {1/To, round(To / Cores)},
	Receiver = spawn(fun() ->aggregate_calculations(S) end),
	Pids = lists:map(fun (El) ->
		{Floor, Ceiling} = {from(El, Delta),to(El, Delta)},
		spawn(fun()-> calculation(Receiver, Floor, Ceiling, Step) end)
	end, lists:seq(1, Cores)),
	Messages = Receiver ! {send_messages, Pids},
	% Sum = lists:sum([receive {sum,S} -> S end || _<-Pids]),
	erlang:display(Sum).

	% io:format("Display items: ~n"),
	% erlang:display(Pids),
	% Sums = aggregate_calculations(Pids),
	% io:format("Display sums ~w~n", [sum(Sums)]),
	% erlang:display(Sums).
	% sum(sums).
	% io:format("PIDS: ~w~n", [aggregate_calculations(Pids)]).
