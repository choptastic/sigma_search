-module (element_sigma_search).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

-export([
	reflect/0,
	render_element/1,
	event/1
]).

-record(postback, {
		results_summary_text,
		results_summary_class,
		textboxid, 
		clearid,
		resultsid,
		tag,
		delegate,
		x_button_text,
		x_button_class
	}).

reflect() -> record_info(fields, sigma_search).


render_element(Rec = #sigma_search{
		placeholder=Placeholder,
		textbox_class=TextboxClass,
		results_class=ResultsClass,
		search_button_class=SearchButtonClass,
		search_button_text=SearchButtonText,
		clear_button_class=ClearClass,
		clear_button_text=ClearText,
		tag=Tag,
		class=WrapperClass,
		results_summary_text=ResultsSummaryText,
		results_summary_class=ResultsSummaryClass,
		x_button_class=XButtonClass,
		x_button_text=XButtonText,
        style=Style
		}) ->
	Textboxid = wf:temp_id(),
	Resultsid = wf:temp_id(),
	SearchButtonid = wf:temp_id(),
	Clearid = wf:temp_id(),
	Delegate = wf:coalesce([Rec#sigma_search.delegate, wf:page_module()]),
	
	Postback = #postback{
		delegate=Delegate,
		tag=Tag,
		textboxid=Textboxid,
		resultsid=Resultsid,
		clearid=Clearid,
		results_summary_text=ResultsSummaryText,
		results_summary_class=ResultsSummaryClass,
		x_button_text=XButtonText,
		x_button_class=XButtonClass
	},

	[
		#panel{class=[sigma_search, WrapperClass], style=Style, body=[
			#textbox{
				class=[sigma_search_textbox, TextboxClass],
				postback=Postback,
				delegate=?MODULE,
				id=Textboxid,
				placeholder=Placeholder,
				actions=[
					#event{type=keydown,postback=Postback,delegate=?MODULE}
				]
			},
			#button{
				id=SearchButtonid,
				class=[sigma_search_button, SearchButtonClass],
				text=SearchButtonText,
				postback=Postback,
				delegate=?MODULE
			},
			#button{
				id=Clearid,
				text=ClearText,
				class=[sigma_search_clear, ClearClass],
				style="display:none",
				click=[
					#set{target=Textboxid, value=""},
					#fade{target=Resultsid},
					#fade{target=Clearid}
				]
			}
		]},
		#panel{
			id=Resultsid,
			class=[sigma_search_results, ResultsClass],
			style="display:none"
		}
	].

event(#postback{
		delegate=Delegate,
		tag=Tag,
		textboxid=Textboxid,
		resultsid=Resultsid,
		clearid=Clearid,
		results_summary_text=ResultsSummaryText,
		results_summary_class=ResultsSummaryClass,
		x_button_class=XButtonClass,
		x_button_text=XButtonText
	}) ->
	case wf:q(Textboxid) of
		"" -> 
			wf:wire(Resultsid,#fade{}),
			wf:wire(Clearid, #fade{});
		Search ->
			{Num, Body} = Delegate:sigma_search_event(Tag, Search),

			ResultsBody = [
				#button{
					text=XButtonText,
					class=[sigma_search_x_button, XButtonClass],
					click="objs('" ++ Clearid ++ "').click()"
				},
				#span{
					class=[sigma_search_results_summary, ResultsSummaryClass],
					text=wf:f(ResultsSummaryText, [Num, Search])
				},
				Body
			],
			wf:update(Resultsid, ResultsBody),
			wf:wire(Clearid, #appear{}),
			wf:wire(Resultsid, #slide_down{})
	end.
