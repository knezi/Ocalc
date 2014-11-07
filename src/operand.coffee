class Operand extends Element	
	constructor: (@display='basic', @type) ->			
		super
		throw 'Operand (constructor): wrong type of operand' unless window.HTML.hasOwnProperty @type
	
	getHTML: ->
		super.html window.HTML[@type]
		
	getValue: ->
		@type