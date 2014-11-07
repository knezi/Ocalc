class Function extends Element	
	constructor: (@display='basic', @type) ->			
		super
		throw 'Operand (constructor): wrong type of operand' unless window.HTML_FUNCTIONS.hasOwnProperty @type
	
	getHTML: ->
		super.addClass('func').html window.HTML_FUNCTIONS[@type]
		
	getValue: ->
		@type