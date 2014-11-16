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
			Math.PI
		else if @name=='e'
			Math.E
