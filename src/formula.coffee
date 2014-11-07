class Formula
	constructor:(@parent=null)->
		@head=new Init()
		@tail=@head
	
	setParent:(@parent)->
	
	getParent:->
		@parent
		
	new: (el, after)->
		unless after
			@tail.setNext el
			el.setPrevious @tail
			@tail=el
		else
			after.getNext()?.setPrevious el
			el.setNext after.getNext()
			after.setNext el
			el.setPrevious after
		
	newBefore: (el, before) ->
		unless before
			@head.setPrevious el
			el.setNext @head
			@head=el
		else
			before.getPrevious().setNext el
			el.setPrevious before.getPrevious()
			before.setPrevious el
			el.setNext before
	
	newAtStart: (el)->
		@new el, @head
	
	swap: (el1, el2)->
		if el1.getNext()==el2
			el1.setNext el2.getNext()
			el1.setPrevious el2
			el2.setNext el1
			el2.setPrevious el1.getPrevios()
		else
			throw 'Formula(swap): wrong elements given'
			
	remove: (el) -> # doesn't work
		el.getPrevious().setNext el.getNext()
		el.getNext().setPrevious el.getPrevious()
	
	solve:->
		cur=@head
		# firstly substitute numbers and reconnect operand to the getResult methods
		loop
			if cur instanceof NumberObj
				{'cur':tmp, 'res':res}=@getNumber cur
				res=new Result res, cur.getPrevious(), tmp?.getNext()
				tmp?.getNext()?.setPreviousResult res					
				cur.getPrevious().setNextResult res
				cur=tmp
			else
				cur.setNextResult cur.getNext()
				cur.getNext()?.setPreviousResult cur
				
			cur=cur?.getNext()
			unless cur
				break
			
		@beforeFunction @head,
			{
				'SIN':(a)->Math.sin a
				'COS':(a)->Math.cos a
				'TAN':(a)->Math.tan a
				'LOG':(a)->Math.log a
			}
		@twoSideOperand @head,					# POW
			{
				'POW':(a,b)->Math.pow a,b
			}
		@twoSideOperand @head,					# HIGH PRIORITE
			{
				'TIMES':(a,b)->a*b
				'DIVIDE':(a,b)->a/b
				'MOD':(a,b)->a%b
			}
		@twoSideOperand @head,					# LOW PRIORITE
			{
				'MINUS':(a,b)->a-b
				'PLUS':(a,b)->a+b
				'AND':(a,b)->a&b
				'XOR':(a,b)->a^b
				'OR':(a,b)->a|b
			}
		@head.getNextResult().getValue()
		
	beforeFunction: (cur, func)->
		while cur
			if cur instanceof Function
				cur_func=cur.getValue()
				if func.hasOwnProperty cur_func
					l=cur.getPreviousResult()
					r=cur.getNextResult()
					res=new Result func[cur_func](r.	getValue()), l.getPreviousResult(), r.getNextResult()
					l.setNextResult res
					r.getNextResult()?.setPreviousResult res
				
			cur=cur?.getNextResult()
	
	twoSideOperand: (cur, oper)->
		while cur
			if cur instanceof Operand
				operand=cur.getValue()
				if oper.hasOwnProperty operand
					l=cur.getPreviousResult()
					r=cur.getNextResult()
					res=new Result oper[operand](l.getValue(),r.getValue()), l.getPreviousResult(), r.getNextResult()
					l.getPreviousResult()?.setNextResult res
					r.getNextResult()?.setPreviousResult res
				
			cur=cur?.getNextResult()
		
	getNumber: (cur)->
		if cur instanceof Brackets
				cur=cur.getNext()
				res=cur.getValue()
		else
			res=''
			loop
				if cur.getValue()=='FLOATPOINT'
					res+='.'
					unless cur.getNext() then throw 'Invalid number'
				else
					res+=cur.getValue()
				unless cur.getNext() instanceof NumberObj
					break
				cur=cur.getNext()
			res=parseFloat res
		{'res': res
		'cur':cur}
	
	display:->
		unless @head is @tail
			cur=@head.getNext()
			form=cur.getHTML()
			$.merge(form,cur.getHTML()) while (cur=cur.getNext())!=null
				
			form
		else
			$('')
