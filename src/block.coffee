class Block extends Element
	constructor: (@display='basic', @formula) ->
		super
	
	getHTML: ->
		super.removeClass('basic').addClass(@display).html @formula.display()
		
	getValue: ->
		console.log 'BLOCK starting'
		value=@formula.solve()
		console.log 'BLOCK ending'
		value
		
	getFormula:->
		@formula
		
	setFormula:(@formula)->
