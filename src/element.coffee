class Element
	# display:
	#	init
	#	basic
	#	bottom
	#	top
	#	block
	#	cursor
	
	constructor: (@display='basic') ->
		@next=null
	
	getHTML: ->
		$("<span class=\'#{@display}\'></span>")

	getPrevious: ->
		@previous
	setPrevious: (@previous) ->
	getNext: ->
		@next
	setNext: (@next) ->
		
	getValue: ->
		null
		
	setNextResult:(@nextResult)->
	setPreviousResult:(@previousResult)->
	getNextResult:->
		@nextResult
	getPreviousResult:->
		@previousResult
