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
		if @head==el
			@head.getNext().setPrevious null
			@head=@head.getNext()
		else if @tail==el
			@tail.getPrevious().setNext null
			@tail=@tail.getPrevious()
		else
			el.getPrevious().setNext el.getNext()
			el.getNext().setPrevious el.getPrevious()

	removeLast:->
		@remove @tail if @tail

	solve:->
		if @head==@tail
			return 0
		else
			cur=@head
			# firstly substitute numbers and reconnect operand to the getResult methods
			loop
				if cur instanceof NumberObj or (cur instanceof Operand and cur.getValue()=='MINUS' and cur.getNext() instanceof NumberObj and not @isNumber(cur.getPrevious()))
			# if cur instanceof NumberObj or (cur instanceof Operand and cur.getValue()=='MINUS' and cur.getNext() and cur.getNext() instanceof NumberObj and cur.getPrevious() and not(cur.getPrevious() instanceof NumberObj) and not(cur.getPrevious() instanceof Variable))
					{'cur':tmp, 'res':res}=@getNumber cur
					res=new Result res, cur.getPrevious(), tmp?.getNext()
					tmp?.getNext()?.setPreviousResult res
					cur.getPrevious().setNextResult res
					cur=tmp
				else
					cur.setNextResult cur.getNext()
					cur.getNext()?.setPreviousResult cur
					
				if (cur instanceof Block or cur instanceof Brackets or cur instanceof Variable) and @isNumber cur.getPrevious()
					t=new Operand cur.display, 'TIMES'
					cur.getPreviousResult().setNextResult t
					t.setPreviousResult cur.getPreviousResult()
					cur.setPreviousResult t
					t.setNextResult cur


				cur=cur?.getNext()
				unless cur
					break

			tail=@head
			tail=tail.getNextResult() while tail.getNextResult()

			@beforeFunction tail,
				{
					'SIN':(a)->Math.sin a/180*Math.PI
					'SININV':(a)->(Math.asin a)*180/Math.PI
					'COS':(a)->Math.cos a/180*Math.PI
					'COSINV':(a)->(Math.acos a)*180/Math.PI
					'TAN':(a)->Math.tan a/180*Math.PI
					'TANINV':(a)->(Math.atan a)*180/Math.PI
					'LOG':(a)->Math.log a
				}

			@afterOperand @head,
				{
					'FACT':@factorial
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

			if @head.getNextResult()==@tail
				throw 'INNERInvalid formula.'

			Math.round(@head.getNextResult().getValue()*Math.pow(10,15))/Math.pow(10,15)
	
	isNumber: (el)->
		el instanceof NumberObj or el instanceof Variable or el instanceof Block or el instanceof Brackets or el instanceof Result
	
	beforeFunction: (cur, func)->
		while cur
			if cur instanceof Function
				cur_func=cur.getValue()
				if func.hasOwnProperty cur_func
					# errors
					unless @isNumber cur.getNextResult()
						throw 'INNERNot a number after '+cur_func+'.'
					l=cur.getPreviousResult()
					r=cur.getNextResult()
					res=new Result func[cur_func](r.getValue()), l.getPreviousResult(), r.getNextResult()
					l.setNextResult res
					r.getNextResult()?.setPreviousResult res
				
			cur=cur?.getPreviousResult()

	afterOperand: (cur, func)->
		while cur
			if cur instanceof Operand
				cur_func=cur.getValue()
				if func.hasOwnProperty cur_func
					# errors
					unless @isNumber cur.getPreviousResult()
						throw 'INNERNot a number before factorial.'

					l=cur.getPreviousResult()
					r=cur.getNextResult()
					res=new Result func[cur_func](l.getValue()), l.getPreviousResult(), r
					l.getPreviousResult()?.setNextResult res
					r?.setPreviousResult res
				
			cur=cur?.getNextResult()
	
	twoSideOperand: (cur, oper)->
		while cur
			if cur instanceof Operand
				operand=cur.getValue()
				if oper.hasOwnProperty operand
					# errors
					unless @isNumber(cur.getPreviousResult()) and @isNumber cur.getNextResult()
						throw 'INNERNot a numbers for '+operand+'.'

					l=cur.getPreviousResult()
					r=cur.getNextResult()
					res=new Result oper[operand](l.getValue(),r.getValue()), l.getPreviousResult(), r.getNextResult()
					l.getPreviousResult()?.setNextResult res
					r.getNextResult()?.setPreviousResult res
				
			cur=cur?.getNextResult()
		
	getNumber: (cur)->
		res=''
		if cur instanceof Operand and cur.getValue()=='MINUS' and cur.getNext() instanceof NumberObj
			res='-'
			cur=cur.getNext()
		loop
			if cur.getValue()=='FLOATPOINT'
				res+='.'
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

	factorial:(a) ->
		unless a==0
			res=1
			for x in [1..a]
				res*=x

			res
		else
			1
