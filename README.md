# Sequencial and Parallel Pi calculations

Simple example of parallel calculations in Erlang.

## Usage:
```
erl
1> c(pi),timer:tc(pi,pi,[10000000]).
{857476,3.141592653589436}  % first value is time of execution, second is pi 
2> c(pi),timer:tc(pi_ll,pi,[10000000]).
{577106,3.1415926535897825} % first value is time of execution, second is pi
```
