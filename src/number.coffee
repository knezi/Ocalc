class NumberObj extends Element
	constructor: (@display='basic', @n) ->
		unless 0<=@n<=9 or @n=='FLOATPOINT' then throw 'number(3): Not number passed to the Number class constructor (' + @n+')'
		super
	
	getHTML: ->
		super.html unless @n=='FLOATPOINT' then @n else ','

	getValue: ->
		@n
