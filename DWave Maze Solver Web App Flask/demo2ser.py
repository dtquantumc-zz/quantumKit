from demo import SolverMaze
from serial import Serial
import time
#from SerialMonitor.ComArduino2PY3 import runTest, waitForArduino, recvFromArduino, sendToArduino

import serial
import time

# Setting up Maze

n_rows = 6
n_cols = 8
start = '0,0n'              # maze entrance location
end = '2,4w'                # maze exit location
walls = ['1,1n', '2,2w']    # maze interior wall locations



def solver(n_rows, n_cols, start, end, walls):
    return SolverMaze(n_rows, n_cols, start, end, walls)
# print(abc)

'''

print ()
print ()
  

NOTE These params are defined in comArduino2PY3.py file
# NOTE the user must ensure that the serial port and baudrate are correct
# serPort = "/dev/ttyS80"
#serPort = "/dev/ttyACM0"
serPort = 'com4'
baudRate = 9600
ser = serial.Serial(serPort, baudRate)
print ("Serial port " + serPort + " opened  Baudrate " + str(baudRate))


startMarker = 60
endMarker = 62


waitForArduino()

# y,x - N,E,S,W
testData = []
testData.append("<First, 0, 0, n>")
testData.append("<First, 1, 0, w>") 
testData.append("<Second, 1, 4, n>")
#testData.append("<Third, 1,4, w>")
#testData.append("<Fourth, 3, 4, n>")
#testData.append("<Fifth, 3, 7, w>")
testData.append("<End, 1, 4, n>")

runTest(testData)

'''