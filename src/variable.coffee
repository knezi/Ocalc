class Variable extends Element
	constructor: (@name, @formula) ->
		super
	
	getHTML: ->
		super.html @name
	
	getValue: ->
		@formula.solve()
