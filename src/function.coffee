class Function extends Element
	constructor: (@display='basic', @type) ->
		super
		throw 'Operand (constructor): wrong type of operand' unless window.HTML_FUNCTIONS.hasOwnProperty @type
	
	getHTML: ->
		inv=''
		if @type.substr(3)=='INV'
			inv='<span class="top">-1</span>'

		super.addClass('func').html window.HTML_FUNCTIONS[@type.substr(0,3)]+inv
		
	getValue: ->
		@type
