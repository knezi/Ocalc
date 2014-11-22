class Result extends Element
	constructor: (@result, @previousResult, @nextResult) ->
		console.log @result
		if @result.toString()=="NaN"
			throw 'INNERError in mathematic function'
		
	getHTML: ->
		null
		
	# immutable
	setPrevious:->
		null
		
	setNext:->
		null
		
	getValue: ->
		@result
