class Cursor
	constructor: (@formula) ->
		@position=@formula
		@displayPosition='basic'
		
	getHigher:->
		@position=@position.parent if @position.parent
		!!@position.parent
		
	new:(el)->
		@position.new el
		
	newAtStart:(el)->
		@position.newAtStart el
		
	newFormula:->
		@formula=new Formula()
		@position=@formula
		@displayPosition='block'
		
	newBlock:(block)->
		@new block
		block.getFormula().setParent @formula
		@position=block.getFormula()
		
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
