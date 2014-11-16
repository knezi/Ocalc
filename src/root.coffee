class Root extends Block
	constructor: (@exp, @formula) ->
		super

	getValue:->
		Math.pow @formula.solve(), 1/@exp.solve()
	
	getHTML: ->
			$("<span class=\'root_exp\'></span>").html(@exp.display())
			.add($("<span class=\'root\'></span>").html(@formula.display()))
