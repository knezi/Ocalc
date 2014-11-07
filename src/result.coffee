class Result extends Element
	constructor: (@result, @previousResult, @nextResult) ->
		
	getHTML: ->
		null
		
	# immutable
	setPrevious:->
		null
		
	setNext:->
		null
		
	getValue: ->
		@result