%% Copyright (c) 2007-2010 Basho Technologies, Inc.  All Rights Reserved.
-module(riak_repl_listener_sup).
-author('Andy Gross <andy@basho.com>').
-behaviour(supervisor).
-export([start_link/0, init/1, stop/1]).
-export([start_listener/2]).

start_listener(IP, Port) ->
    error_logger:info_msg("Starting replication listener on ~s:~p~n",
                          [IP, Port]),
    supervisor:start_child(?MODULE, [IP, Port]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_S) -> ok.

%% @private
init([]) ->
    {ok, 
     {{simple_one_for_one, 10, 10}, 
      [{undefined,
        {riak_repl_listener, start_link, []},
        temporary, brutal_kill, worker, [riak_repl_listener]}]}}.
