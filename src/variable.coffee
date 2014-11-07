class Variable extends Element
	constructor: (@display='basic', @name, @formula) ->
		super
	
	getHTML: ->
		super.html @name
	
	getValue: ->
		@formula.solve()