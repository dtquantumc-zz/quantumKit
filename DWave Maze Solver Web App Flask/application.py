#!flask/bin/python
import os
from demo import SolverMaze
import sys
import requests
import numpy as np


from flask import Flask, render_template, request, redirect, Response
import random, json


n_rows = 6
n_cols = 8
start = '0,0n'              # maze entrance location
end = '2,4w'                # maze exit location
walls = ['1,1n', '2,2w']

#solution, vis = SolverMaze(n_rows, n_cols, start, end, walls)
#solution, visu = SolverMaze(n_rows, n_cols, start, end, walls)
#visa = ("\n".join(visu))
#vis = np.reshape(np.asarray(visu), (13,1))


app = Flask(__name__)
app.config['DEBUG'] = True


@app.route('/', methods = ['GET'])
def output():
	# serve index template
	
	#return render_template('index.html', name='Joe', mazesoln=solution, visual=vis)
	return render_template('index.html')#, name='Joe')

@app.route('/receiver', methods = ['GET', 'POST'])
def worker():
	# read json + reply
	data = request.get_json()
	solution, visu = SolverMaze(data[0]['value'], data[1]['value'], data[2]['value'], data[3]['value'], data[4]['value'])
	visa = ("\n".join(visu))
	vis = np.reshape(np.asarray(visu), (13,1))
	#print(solution)
	return str(solution)


@app.route('/testing', methods=['GET', 'POST'])
def fn():
	data = request.get_data()
	data = data.decode("utf-8")
	print(data)
	data = data.split('&')
	i=0
	while i < len(data):
		data[i] = data[i].split("=")[1]
		i=i+1
	del data[1]
	print(data)
	data[0], data[1], data[4] = int(data[0]), int(data[1]), data[4].split('%3B')
	data[2] = data[2].replace('%2C', ',')
	data[3] = data[3].replace('%2C', ',')
	j = 0
	while (j < len(data[4])):
		data[4][j] = data[4][j].replace('%2C', ',')
		j=j+1
	
	# sending the inputs to the D-Wave machine
	solution2, visu2 = SolverMaze(data[0], data[1], data[2], data[3], data[4])
	
	#visa = ("\n".join(visu))
	#vis = np.reshape(np.asarray(visu), (13,1))

	return str(solution2)

if __name__ == '__main__':
	# run!
	port = int(os.environ.get("PORT", 5000))
	app.run(debug=True, host='0.0.0.0', port=port)
	#app.run(debug=True)