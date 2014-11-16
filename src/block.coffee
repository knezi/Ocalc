class Block extends Element
	constructor: (@display='basic', @formula) ->
		super
	
	getHTML: ->
		super.removeClass('basic').addClass(@display).html @formula.display()
		
	getValue: ->
		@formula.solve()
		
	getFormula:->
		@formula
		
	setFormula:(@formula)->
