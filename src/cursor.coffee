class Cursor
	constructor: (@formula) ->
		@position=@formula
	
	canHigher:->
		!!@position.parent
		
	getHigher:->
		@position=@position.parent if @position.parent
		!!@position.parent
		
	new:(el, formula)->
		@position.new el
		if el instanceof Root
			el.formula.setParent @position
			el.exp.setParent el.formula
			@position=el.exp

		if el instanceof Block
			el.getFormula().setParent @position
			@position=el.getFormula()

		if el instanceof Function and el.type='LOG'
			b=new Block 'bottom', formula
			@position.new b # can't call just @new because it is instance of Block
			b.getFormula().setParent @position
			@position=b.getFormula()

		
	newAtStart:(el)->
		@position.newAtStart el
		
	newFormula:->
		@formula=new Formula()
		@position=@formula

	display:->
		@formula.display()
		
	solve:->
		@formula.solve()

	formulaInBlock:(block, beginning...)->
		block.setFormula @formula
		@newFormula()
		block.getFormula().setParent @formula
		for x in beginning
			@new x
		@new block
		@position=block.getFormula()

	pop:->
		unless @position.tail==@position.head
			@position.removeLast()
		else unless @position==@formula
			@position=@position.parent
			@pop()
