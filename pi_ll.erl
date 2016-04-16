-module(pi_ll).
-export([start/0, calculations_process/0, calculate/3, rpc/2]).

calculate(To, To, H) ->
	X = (To - 0.5) * H,
	(4.0/(1.0 + X * X));

calculate(From, To, H) ->
	X = (From - 0.5) * H,
	(4.0/(1.0 + X * X)) + calculate(From + 1, To, H).

rpc(Pid, Request) ->
	Pid ! { self(), Request },
	receive
		{Pid, {result, Sum}} ->
			io:format("*response from calculations_process~n"),
			Sum;
		Other->
			io:format("*received unknown ~p, ~n",[Other])
	end.

calculations_process()->
  receive
    {Pid, {Sum, {From, To, H}}} ->
			io:format("received correct command ~n"),
      Pid ! {self(), {result, (Sum + calculate(From, To, H)*H)}},
      calculations_process();
    Other ->
      io:format("unknown command ~p ~n",[Other]),
      calculations_process()
  end.

start()->
	Pid = spawn(fun calculations_process/0),
	X = rpc(Pid, {0, {1,30000000,1/100000000}}),
	Y = rpc(Pid, {0, {30000001,60000001,1/100000000}}),
	Z = rpc(Pid, {0, {60000001,100000001,1/100000000}}),
	io:format("Result: ~p~n",[X+Y+Z]),
	erlang:halt().
