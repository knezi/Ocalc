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

fillVar=(v)->
	console.log 'fill'
	console.log v
	$('#'+v).addClass 'filled'

showError=(e)->
	$('#error_line').html e

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
			cursor.new new Operand cursor.displayPosition, type
			window.resultShown=false
			
		else if window.HTML_FUNCTIONS.hasOwnProperty type	# Functions
			if window.resultShown and type!='LOG'
					cursor.formulaInBlock new Brackets(cursor.displayPosition), new Function cursor.displayPosition, type
					window.resultShown=false
			else
				if type=='LOG' and window.resultShown
					cursor.newFormula()
					window.resultShown=false
				cursor.new new Function cursor.displayPosition, type
				if type=='LOG'
					cursor.displayPosition='bottom'
					upActivated true
			
		else if 0<=parseInt(type)<=9 or type=='FLOATPOINT'	# Numbers
			if window.resultShown
				cursor.newFormula()
				window.resultShown=false
			cursor.new new NumberObj cursor.displayPosition, type

		else if type in window.CONST						# Contants
			if window.resultShown
				cursor.newFormula()
				window.resultShown=false

			cursor.new new Constant cursor.displayPosition, type

		else if type.substr(1,2)=='AS'						# Variable assigment
			window.vars[type.substr(0,1)]=cursor.formula
			fillVar 'VAR'+type.substr(0,1)

		else if type.substr(0,3)=='VAR' and 				# Variable reading
				window.vars[type.substr(3)]
			if window.vars[type.substr(3)]==cursor.formula
				throw "You can't use formula recursively"
			cursor.new new Brackets cursor.displayPosition, window.vars[type.substr(3)]

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
				cursor.formulaInBlock new Brackets(cursor.displayPosition), new NumberObj(cursor.displayPosition, '1'), new Operand(cursor.displayPosition, 'DIVIDE')
				window.resultShown=false
			when 'BRACKETS'									# Brackets
				upActivated true
				if window.resultShown
					cursor.formulaInBlock new Brackets cursor.displayPosition
					window.resultShown=false
				else
					cursor.newBlock new Brackets cursor.displayPosition, new Formula()
			
			when 'SOLVE'									# Solve
				showError ''
				res=cursor.solve()
				res=String(res).split 'e'
				cursor.newFormula()
				for x in res[0]
					if x=='-'
						cursor.new new Operand cursor.displayPosition, 'MINUS'
					else
						if x=='.'
							x='FLOATPOINT'
						cursor.new new NumberObj cursor.displayPosition, x

				if res.length==2
					cursor.new new Operand cursor.displayPosition, 'TIMES'
					cursor.new new NumberObj cursor.displayPosition, 1
					cursor.new new NumberObj cursor.displayPosition, 0
					cursor.new new Operand cursor.displayPosition, 'POW'
					for x in res[1]
						if x=='+'
							continue
						if x=='-'
							cursor.new new Operand cursor.displayPosition, 'MINUS'
						else
							cursor.new new NumberObj cursor.displayPosition, x

				window.resultShown=true
		
			when 'UP'										# Up
				if cursor.displayPosition=='bottom' or cursor.displayPosition=='top'
					upActivated false unless cursor.canHigher()
					cursor.displayPosition='basic'
				else
					upActivated cursor.getHigher()

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
			
		window.form.html cursor.display()

	catch e # from 64
		console.log cursor.formula.head
		console.log e
		if e.substr(0,5)=='INNER'
			showError e.substr 5
		else
			alert "We are sorry, but an unexpected error occured:\n"+e+"\nPlease contact us."
			

		
window.hold=undefined
window.holdPos=0

$('td').each ()->
	console.log this
	Hammer(this, {'time':200}).on 'press',
		(obj)->
			window.navigator.vibrate(70)
			console.log this
			window.hold=$(obj.target).addClass 'active'
			window.holdPos=obj.center.y
			console.log 'press'
	
document.addEventListener 'touchmove', (obj)->
				if window.hold and window.holdPos+10<obj.touches[0].clientY
					tap window.hold.data('down')
					window.hold=undefined
					console.log 'release'

$('table').addEventListener 'touchend', (obj)->
		window.hold=undefined

$('td').click((e)->tap($(e.target).data('tap')))
