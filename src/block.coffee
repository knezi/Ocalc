class Block extends Element
	constructor: (@display='basic', @formula) ->
		super
	
	getHTML: ->
		super
		
	getValue: ->
		@formula.solve()
		
	getFormula:->
		@formula
		
	setFormula:(@formula)->