class Constant extends Variable
	constructor: (@name, @value) ->
		super
		
	getHTML:->
		if @name=='PI'
			 super.html '&Pi;'
		else if @name=='e'
			super.html 'e'


	getValue: ->
		if @name=='PI'
			window.PI
		else if @name=='e'
			window.e
