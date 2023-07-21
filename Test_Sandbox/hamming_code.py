import numpy as np
import pandas as pd
import operator as op
from functools import reduce

# TODO: scale to 64-bit table
# currently there are 16 bits in a block; hoping to increase to 64, 256, etc. later
bitBlockSize = 16

# option for user to input 11 "message bits" and I will fill in the correct parity bits
print("Enter 11-bit message (idx 3, 5-7, 9-15 of 16-bit block)\nOr type 'R' for a random example")
sendingBits = [0 for i in range(bitBlockSize)]
validMsgIndex = [3,5,6,7,9,10,11,12,13,14,15]
for i in validMsgIndex:
    while True:
        bit = input(f"Bit w/ index = {i}: ")
        if bit == '0' or bit == '1':
            sendingBits[i] = int(bit)
            break
        elif bit == 'R' or bit == 'r':
            sendingBits = np.random.randint(0, 2, bitBlockSize)
            break
        else:
            print("Invalid input. Please enter 0 or 1 (or R for random).")
    if bit == 'R' or bit == 'r':
        break

# print the bits received to look like a 4 x 4(n x n) table
print(np.reshape(sendingBits, (4, 4)))

# pull positions with "on bits" 
onBits = [i for i, bit in enumerate(sendingBits) if bit == 1]
onBitsDict = {i:bit for i, bit in enumerate(sendingBits) if bit == 1}

# use xor on all the positions with "on bits" to check parity (must be 0)
parityCheck = reduce(op.xor, onBits)

# create a valid hamming code out of a random message if it wasn't randomly correct
print(f"parityCheck is %i; in binary that is %s" % (parityCheck, format(parityCheck, '04b')))

if parityCheck == 0:
    print("The random bit pattern is a valid hamming code, noice!")
    
else:    
    # find how many parity bits there should be and create a dict of lists to store the relevant bits for each parity bit
    parityLists = {}
    numParityBits = np.log2(bitBlockSize)
    for i in range(int(numParityBits)):
        parityLists[i] = []

    # Iterate over binary versions of the index to create the list of relevant bits for each parity bit
    # also get the index of each parity bit and store it for later
    parityBitIndex = []
    for j in range(int(numParityBits)):
        for i in range(bitBlockSize + 1):
            binary = format(i, '04b')
            
            if binary[-(j+1)] == '1':
                parityLists[j].append(i)
                
        parityBitIndex.append(parityLists[j][0])
                        
    # check each parity region and change the parity bit if not even
    print("Parity check failed, flipping necessary parity bits (can be index 1, 2, 4 and/or 8)")

    # sum of all bits if the index is within the parity list
    for i, regionList in parityLists.items():
        regionBitValues = [sendingBits[index] for index in regionList]
        
        if sum(regionBitValues) % 2 != 0:
            # flip the parity bit
            sendingBits[parityBitIndex[i]] = not sendingBits[parityBitIndex[i]]
            
    # flip "double error" bit at sendingBits[0][0] if necessary
    if sum(sendingBits) % 2 != 0:
        print("Also have to flip the 'double error checker' (AKA element 0)")
        sendingBits[0] = not sendingBits[0]
        
    # display the results
    print(np.reshape(sendingBits, (4, 4)))
    onBits = [i for i, bit in enumerate(sendingBits) if bit == 1]
    parityCheck = reduce(op.xor, onBits)
    print(f"parityCheck is %i; in binary that is %s" % (parityCheck, format(parityCheck, '04b')))
    if parityCheck == 0:
        print("This is now a valid, hamming-code protected message, ready for sending :)")
        print()


# simulates a 1** or 2 (later 3) bit error in the 11 message received bits
def simulateMessageError():
    error = np.random.randint(0, 11)
    errorMap = {0:3, 1:5, 2:6, 3:7, 4:9, 5:10, 6:11, 7:12, 8:13, 9:14, 10:15}
    errorIDX = errorMap[error]
    sendingBits[errorIDX] = not sendingBits[errorIDX]
    

def msgErrorFixSim():
    print("Now your message contains a 1-bit error, look! (before/after)")
    print(np.reshape(sendingBits, (4, 4)))
    print("-----------")
    
    # 1 bit error in message bits
    simulateMessageError()
    print(np.reshape(sendingBits, (4, 4)))
    onBits = [i for i, bit in enumerate(sendingBits) if bit == 1] 
    parityCheck = reduce(op.xor, onBits) # xor (kinda like sum in this case) down the list to perform a parity check
    print("Parity check index will tell us where the error was...")
    print(f"parityCheck is %i; in binary that is %s" % (parityCheck, format(parityCheck, '04b')))

    # make the fix based on the parity check index and show results
    print(f"Great, fixing erroneous bit at index = {parityCheck}\nNow let's look back at the message and perform another parity check...")
    sendingBits[parityCheck] = not sendingBits[parityCheck]
    print(np.reshape(sendingBits, (4, 4)))
    
    # check parity again after fix
    onBits = [i for i, bit in enumerate(sendingBits) if bit == 1]
    parityCheck = reduce(op.xor, onBits)
    print(f"parityCheck is %i; in binary that is %s" % (parityCheck, format(parityCheck, '04b')))
    print("You have fixed the damaged bit! This is once again a sendable message")
    print()
    
while (True):
    errorChoice = input("Would you like to simulate an error?\n - M = 1 bit error in message\n - P = 1 bit error in parity bits\n - A = 1 bit error anywhere in the message\n - Q = Quit\nEnter an option: ")
    print()
    if errorChoice == 'M' or errorChoice == 'm':
        msgErrorFixSim()
    elif errorChoice == 'Q' or errorChoice == 'q':
        break
    else:
        print("Not a valid menu option...")
        print()
        
    

# TODO: create a function that simulates a 1 or 2 (later 3) bit error in the 4 parity bits

# TODO: create a function that simulates a 1 or 2 (later 3) bit error in the message received and parity bits (16-bits)

# TODO: create a function that fixes errors in the parity bits or message received




