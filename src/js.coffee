window.HTML={
	'MINUS':'-'
	'PLUS':'+'
	'AND':'AND'
	'XOR':'XOR'
	'OR':'OR'
	'TIMES':'&times;'
	'DIVIDE':'/'
	'MOD':'%'
	'POW':'&circ;'
	'FACT':'!'
}

window.HTML_FUNCTIONS={
	'SIN':'sin'
	'SININV':'sinINV'
	'COS':'cos'
	'COSINV':'cosINV'
	'TAN':'tan'
	'TANINV':'tanINV'
	'LOG':'log'
}

window.CONST=[
	'PI',
	'e'
]

window.vars={
	'X':null,
	'Y':null,
	'Z':null
}

window.varsUsed={
	'X':null,
	'Y':null,
	'Z':null
}

$(window).resize ->
	size=parseInt($(window).width())-4
	size_text=parseInt($(window).height())/15+'px'
	$('body').css {'font-size':size_text, 'line-height':size_text}
	$('#cont_disp').css {width:size+'px'}
	$('table tr td').css {width: parseInt(size/7)}
	
window.up=$('#UP_BTN')
upActivated=(act)->
	if act
		window.up.removeClass 'deactivated'
	else
		window.up.addClass 'deactivated'

upBlink=->
	window.up.children()
		.removeClass 'blink'
		.addClass 'set_blink'
	setTimeout (()->window.up.children().addClass('blink')), 25


fillVar=(v)->
	$('#'+v).addClass 'filled'

showError=(e)->
	$('#error_line').html e

factorialise=(n,first)->
	prime=0
	pow=0
	for x in [2..Math.sqrt(n)+1]
		if n%x==0
			prime=x
			break

	if prime==0
		prime=n
		pow=1
		n=1

	while n%x==0
		n/=x
		pow++
	
	unless first
		cursor.new new Operand 'TIMES'
	for y in prime.toString()
		cursor.new new NumberObj y

	if pow>1
		cursor.new new Operand 'POW'
		for y in pow.toString()
			cursor.new new NumberObj y

	n

$(window).trigger('resize')
window.resultShown=false
window.form=$('#formula')
window.formula=new Formula()

cursor=new Cursor window.formula
window.form.html window.formula.display()


tap=(type)->
	try
		console.log type #TEMP
		if window.HTML.hasOwnProperty type					# Operands
			cursor.new new Operand type
			window.resultShown=false
			
		else if window.HTML_FUNCTIONS.hasOwnProperty(type) or# Functions
		type.toString().substr(0,3)=='LOG'
			isLog=type.substr(0,3)=='LOG'
			if isLog
				formula=new Formula()
				if type.substr(3)=='2'
					formula.new new NumberObj 2
				if type.substr(3)=='10'
					formula.new new NumberObj 1
					formula.new new NumberObj 0
				type_old=type
				type='LOG'
			else
				formula=undefined

			if window.resultShown and not isLog
					cursor.formulaInBlock new Brackets(), new Function type
					window.resultShown=false
			else
				if isLog and window.resultShown
					cursor.newFormula()
					window.resultShown=false
				cursor.new new Function(type), formula
				unless isLog
					cursor.new new Brackets 'basic', new Formula()
				if isLog and type_old!='LOG' # already has index
					cursor.getHigher()
			
		else if 0<=parseInt(type)<=9 or type=='FLOATPOINT'	# Numbers
			if window.resultShown
				cursor.newFormula()
				window.resultShown=false
			cursor.new new NumberObj type

		else if type in window.CONST						# Contants
			if window.resultShown
				cursor.newFormula()
				window.resultShown=false

			cursor.new new Constant type

		else if type.substr(1,2)=='AS'						# Variable assigment
			window.vars[type.substr(0,1)]=jQuery.extend true, {}, cursor.formula
			window.varsUsed[type.substr(0,1)]=cursor.formula
			fillVar 'VAR'+type.substr(0,1)

		else if type.substr(0,3)=='VAR' and 				# Variable reading
				window.vars[type.substr(3)]
			if window.varsUsed[type.substr(3)]==cursor.formula
				throw "INNERYou can't use formula recursively"
			cursor.newBrackets window.vars[type.substr(3)]

		else if type.substr(0,3)=='EXP'						# Exponent
			tap 'TIMES'
			tap '1'
			tap '0'
			tap 'POW'
			if type.substr(3)=='-3'
				tap 'MINUS'
				tap '3'
			if type.substr(3)=='3'
				tap '3'
			window.resultShown=false

		else if type.substr(0,3)=='POW'
			tap 'POW'
			tap type.substr(3)
			window.resultShown=false

			
		else switch type
			when 'INVNUM'									# Inversion number
				cursor.formulaInBlock new Brackets(), new NumberObj('1'), new Operand('DIVIDE')
				window.resultShown=false
			when 'BRACKETS'									# Brackets
				if window.resultShown
					cursor.formulaInBlock new Brackets('basic')
					window.resultShown=false
				else
					cursor.new new Brackets 'basic', new Formula()
			
			when 'SOLVE'									# Solve
				showError ''
				res=cursor.solve()
				console.log res
				if res==Infinity
					throw 'INNERToo big or too small number'

				res=String(res).split 'e'
				cursor.newFormula()
				for x in res[0]
					if x=='-'
						cursor.new new Operand 'MINUS'
					else
						if x=='.'
							x='FLOATPOINT'
						cursor.new new NumberObj x

				if res.length==2
					cursor.new new Operand 'TIMES'
					cursor.new new NumberObj 1
					cursor.new new NumberObj 0
					cursor.new new Operand 'POW'
					for x in res[1]
						if x=='+'
							continue
						if x=='-'
							cursor.new new Operand 'MINUS'
						else
							cursor.new new NumberObj x

				window.resultShown=true
		
			when 'SOLVE_FACT'								# Solve and factorialise
				showError ''
				res=Math.round(cursor.solve())
				console.log res
				cursor.newFormula()
			
				t=factorialise res, true
				while t!=res and t>1
					res=t
					t=factorialise res, false

				window.resultShown=true

			when 'UP'										# Up
				if cursor.canHigher()
					cursor.getHigher()
					upBlink()


			when 'PERCENTAGE'
				tap 'TIMES'
				tap '0'
				tap 'FLOATPOINT'
				tap '0'
				tap '1'
				tap 'TIMES'


			when 'REMOVE'
				cursor.pop()
				window.resultShown=false

			when 'REMOVE_ALL'
				if confirm('Really delete the whole formula?')
					cursor.newFormula()
				
			when 'ROOT'
				if window.resultShown
					cursor.newFormula()
					window.resultShown=false
				cursor.new new Root new Formula(), new Formula()

			when 'ROOT2'
				if window.resultShown
					cursor.newFormula()
					window.resultShown=false
				r=new Root new Formula(), new Formula()
				r.exp.new new NumberObj 2
				cursor.new r
				cursor.getHigher()
			
			when 'ROOT3'
				if window.resultShown
					cursor.newFormula()
					window.resultShown=false
				r=new Root new Formula(), new Formula()
				r.exp.new new NumberObj 3
				cursor.new r
				cursor.getHigher()

			when 'INFO'
				$('#info').show(1000)
				$('#info').click ()->
					$(this).hide(1000)

		upActivated cursor.canHigher()
		window.form.html cursor.display()

	catch e # from 64
		console.log e
		if e.substr(0,5)=='INNER'
			showError e.substr 5
		else
			alert "We are sorry, but an unexpected error occured:\n"+e+"\nPlease contact us."

	return
			

		
window.hold=undefined
window.holdPos=0

document.addEventListener 'mousedown', (obj)->
	if obj.target.nodeName.toUpperCase()=="SPAN"
		obj=obj.target.parentNode
	else
		obj=obj.target
	if obj.nodeName.toUpperCase()=="TD"
		tap obj.dataset['tap']
	return

$('td').each ()->
	Hammer(this, {'time':200}).on 'press',
		(obj)->
			window.navigator.vibrate(70)
			window.holdPos=obj.center.y
			jObj=$(obj.target)
			if jObj[0].nodeName.toUpperCase()=='SPAN'
				jObj=jObj.parent()
				
			window.hold=jObj.addClass 'active'
			return
	return
	
document.addEventListener 'touchmove', (obj)->
	if window.hold
		if window.holdPos+10<obj.touches[0].clientY and window.hold.data('down')!=undefined
			if window.hold.data('down')!='REMOVE_ALL'
				tap window.hold.data('down')
				window.hold=undefined
			else
				window.hold=undefined
				tap 'REMOVE_ALL'
		if window.holdPos-10>obj.touches[0].clientY and window.hold.data('up')!=undefined
			tap window.hold.data('up')
			window.hold=undefined

	return

document.addEventListener 'touchend', (obj)->
		window.hold=undefined
		return

