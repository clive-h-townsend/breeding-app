import csv

# fileList = [
#     '2015-1.csv',
#     '2015-2.csv',
#     '2015-3.csv',
#     '2015-4.csv',
#     '2016-1.csv',
#     '2016-2.csv',
#     '2016-3.csv',
#     '2016-4.csv',
#     '2017-4.csv',
#     '2018-1.csv',
#     '2018-2.csv',
#     '2018-3.csv',
#     '2018-4.csv',
#     '2018-5.csv'
# ]

fileList = ['animals.csv']

sourceOrTest = './TestData/'

filePath = sourceOrTest + 'allData.csv'
cFile = open(filePath, 'w')



numOfFiles = len(fileList)

i = 0

while i < numOfFiles:
    dataFile = open(sourceOrTest + fileList[i])
    headers = dataFile.readline().replace('"', '').replace('(', '').replace(')', '')
    if (i == 0):
        cFile.write(headers)
        lineRead = dataFile.readline().replace('"', '').replace('(', '').replace(')', '')
    else:
        lineRead = dataFile.readline().replace('"', '').replace('(', '').replace(')', '')

    while lineRead != '':
        if len(lineRead) > 10:
            cFile.write(lineRead)
        lineRead = dataFile.readline().replace('"', '').replace('(', '').replace(')', '')

    i = i + 1

cFile.close()

bFile = open(filePath)
lineRead = bFile.readline()
lineRead = bFile.readline().replace('\n', '')

dataArray = []

while lineRead != '':
    lineRead = lineRead.split(',')

    dataArray.append(lineRead)

    lineRead = bFile.readline().replace('\n', '')

cleanArray = []
numEntries = len(dataArray)
i = 0
cleanFile = open(sourceOrTest + 'CleanData.csv', 'w')
cleanFile.write(',' + headers.replace('\n', '') + ',Bads,adf')
counter = 1
while i < numEntries:
    duplicate = False
    k = 0
    numClean = len(cleanArray)
    while k < numClean:
        if cleanArray[k] == dataArray[i]:
            duplicate = True
        k = k + 1
    if duplicate == False:
        cleanArray.append(dataArray[i])
        j = 0
        dataPoints = len(dataArray[i])
        lineOut = str(counter) + ','
        counter = counter + 1
        while j < dataPoints:
            lineOut = lineOut + dataArray[i][j] + ','
            j = j + 1
        cleanFile.write(lineOut + '\n')
    
    i = i + 1

print('Done')