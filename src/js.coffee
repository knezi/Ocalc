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
}

window.HTML_FUNCTIONS={
	'SIN':'sin'
	'COS':'cos'
	'TAN':'tan'
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

$(window).trigger('resize')
window.resultShown=false
window.form=$('#formula')
window.formula=new Formula()

cursor=new Cursor window.formula
window.form.html window.formula.display()


tap=(obj)->
	type=$(obj.currentTarget).data 'tap'
	console.log type #TEMP
	if window.HTML.hasOwnProperty type					# Operands
		cursor.new new Operand cursor.displayPosition, type
		window.resultShown=false
		
	else if window.HTML_FUNCTIONS.hasOwnProperty type	# Functions
		if window.resultShown
				cursor.formulaInBlock new Brackets(cursor.displayPosition), new Function cursor.displayPosition, type
				window.resultShown=false
		else
			cursor.new new Function cursor.displayPosition, type
		
	else if 0<=parseInt(type)<=9 or type=='FLOATPOINT'	# Numbers
		if window.resultShown
			cursor.newFormula()
			window.resultShown=false
		cursor.new new NumberObj cursor.displayPosition, type
		
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
			res=cursor.solve()
			cursor.newFormula()
			for x in String res
				if x=='-'
					cursor.new new Operand cursor.displayPosition, 'MINUS'
				else
					if x=='.'
						x='FLOATPOINT'
					cursor.new new NumberObj cursor.displayPosition, x
			window.resultShown=true
	
		when 'UP'										# Up
				upActivated cursor.getHigher()
		
	window.form.html cursor.display()
		
#$('td').hammer({}).bind 'tap', tap
console.log 'connect'
$('td').hammer({}).bind 'tap', tap
#$('td').hammer({}).bind 'swipedown', ->console.log 'a'
