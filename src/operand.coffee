class Operand extends Element
	constructor: (@type) ->
		super
		throw "Operand (constructor): wrong type of operand (#{@type})" unless window.HTML.hasOwnProperty @type
	
	getHTML: ->
		super.html window.HTML[@type]
		
	getValue: ->
		@type
