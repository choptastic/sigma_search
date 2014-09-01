# sigma_search

A search form [Nitrogen Web Framework](http://nitrogenproject.com)

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

## Element Attributes

+ `tag` = The `Tag` value that will be passed to `Module:sigma_search_event/2`
+ `placeholder` = Placeholder text for the textbox. (ex: "Search by player name or email")
+ `delegate` = The module to post the `sigma_search_event/2` function
+ `class` = The class of the wrapper div
+ `textbox_class` = The class of the search textbox
+ `search_button_class` = The class of the "Search" button
+ `search_button_text` = The text to go into the Search button (default: `"Search"`)
+ `clear_button_class` = The class of the "Clear Search Results" button
+ `clear_button_text` = The text of the "Clear Search Results" button (default: "Clear")
+ `x_button_class` = In the corner of the search results displays an "X" button to close the search results and reset the form.  This is the class for that button.
+ `x_button_text` = The text of the "X" button (default "X")
+ `results_class` = The class of the div for the search results
+ `results_summary_text` = An `io_lib:format`ted string for displaying both the number of results and the search text. Default `"~p search results for \"~s\""`
+ `results_summary_class` = The class of the "Results Summary" above

## License

Copyright (c) 2013, [Jesse Gumm](http://sigma-star.com/page/jesse)
([@jessegumm](http://twitter.com/jessegumm))

MIT License
