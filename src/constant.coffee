class Constant extends Variable
	constructor: (@display='basic', @name, @value) ->
		super
		
	getValue: ->
		@value