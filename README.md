# sigma_search

A search form [Nitrogen Web Framework](http://nitrogenoproject.com)

## Installing into a Nitrogen Application

Add it as a rebar dependency by adding into the deps section of rebar.config:

```erlang
	{sigma_search, ".*", {git, "git://github.com/choptastic/sigma_search.git", {branch, master}}}
```

### Using Nitrogen's built-in plugin installer (Requires Nitrogen 2.2.0)

Run `make` in your Application. The rest should be automatic.

### Manual Installation (Nitrogen Pre-2.2.0)

Run the following at the command line:

```shell
	./rebar get-deps
	./rebar compile
```

Then add the following includes into any module requiring the form

```erlang
	-include_lib("sigma_search/include/records.hrl").
```

## Usage

Add the following to the body of a page

```erlang
	#sigma_search{
		tag=search,
		placeholder="Enter something here to search for"
	}
```

Then add a `sigma_search_event/2` function to your page (be sure it's exported)

```erlang
sigma_search_event(Tag, SearchText) ->
	NumberOfResults = my_search_module:count(SearchText),
	FormattedResults = my_search_module:format(SearchText),
	{NumberOfResults, FormattedResults}.
```

`sigma_search_event/2` must return a 2-tuple, with the first element being the
number of results returned (an integer), and the second being Nitrogen or 
HTML elements.

## License

Copyright (c) 2013, [Jesse Gumm](http://sigma-star.com/page/jesse)
([@jessegumm](http://twitter.com/jessegumm))

MIT License
