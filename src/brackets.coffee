class Brackets extends Block
	constructor: (@display='basic', @formula) ->
		super
	
	getHTML: ->
		$("<span type=\'#{@display}\'>(</span>").add(super.addClass('brackets')).add "<span type=\'#{@display}\'>)</span>"
