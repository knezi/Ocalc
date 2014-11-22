class Block extends Element
	constructor: (@display='basic', @formula) ->
		super
	
	getHTML: ->
		super.removeClass('basic').addClass(@display).html @formula.display()
		
	getValue: ->
		value=@formula.solve()
		value
		
	getFormula:->
		@formula
		
	setFormula:(@formula)->
