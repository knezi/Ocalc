fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

task 'build', 'Build lib/ from src/', ->
	coffee = spawn 'coffee', ['-b', '-c', '-o', 'lib', 'src']
	coffee.stderr.on 'data', (data) ->
		process.stderr.write data.toString()
	coffee.stdout.on 'data', (data) ->
		print data.toString()
