class Element
	# display:
	#	init
	#	basic
	#	bottom
	#	top
	#	block
	#	cursor
	
	constructor: () ->
		@next=null
	
	getHTML: ->
		$("<span class=\'basic\'></span>")

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
