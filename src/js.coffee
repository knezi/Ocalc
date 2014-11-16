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

upBlink=->
	console.log 'ahoj'
	window.up.css({'background':'yellow'})
	setTimeout (()->window.up.css({'background':'#e7e7e7', 'transition':'3s'})), 25
	setTimeout (()->window.up.css({'transition':'0s'})), 50


fillVar=(v)->
	console.log 'fill'
	console.log v
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
# window.form.html window.formula.display() TEMP


tap=(type)->
	# try
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
			window.vars[type.substr(0,1)]=cursor.formula
			fillVar 'VAR'+type.substr(0,1)

		else if type.substr(0,3)=='VAR' and 				# Variable reading
				window.vars[type.substr(3)]
			if window.vars[type.substr(3)]==cursor.formula
				throw "You can't use formula recursively"
			cursor.new new Brackets window.vars[type.substr(3)]

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
				res=cursor.solve()
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
					console.log "DELETING FORMULA"
					cursor.newFormula()
				
			when 'ROOT'
				cursor.new new Root new Formula(), new Formula()

			when 'ROOT2'
				r=new Root new Formula(), new Formula()
				r.exp.new new NumberObj 2
				cursor.new r
				cursor.getHigher()
			
			when 'ROOT3'
				r=new Root new Formula(), new Formula()
				r.exp.new new NumberObj 3
				cursor.new r
				cursor.getHigher()


		upActivated cursor.canHigher()
		window.form.html cursor.display()

	# catch e # from 64
		# console.log cursor.formula.head
		# console.log e
		# if e.substr(0,5)=='INNER'
			# showError e.substr 5
		# else
			# alert "We are sorry, but an unexpected error occured:\n"+e+"\nPlease contact us."
			

		
window.hold=undefined
window.holdPos=0

$('td').each ()->
	Hammer(this).on 'tap',
		(obj)->
			console.log 'tap'
			tap($(obj.target).data('tap'))

$('td').each ()->
	# console.log this
	Hammer(this, {'time':200}).on 'press',
		(obj)->
			window.navigator.vibrate(70)
			console.log this
			window.hold=$(obj.target).addClass 'active'
			window.holdPos=obj.center.y
			console.log 'press'
	
document.addEventListener 'touchmove', (obj)->
	if window.hold
		if window.holdPos+10<obj.touches[0].clientY
			tap window.hold.data('down')
			window.hold=undefined
			console.log 'release'
		if window.holdPos-10>obj.touches[0].clientY and window.hold.data('up')!=undefined
			tap window.hold.data('up')
			window.hold=undefined
			console.log 'release'

$('table').addEventListener 'touchend', (obj)->
		window.hold=undefined


# $('td').click((e)->tap($(e.target).data('tap')))
