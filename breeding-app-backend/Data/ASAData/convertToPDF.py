fileName = 'Hybrid.txt'
cdf = open(file=fileName)

header = cdf.readline().replace('\n', '').split('\t')

lineRead = cdf.readline()

data = []

while lineRead != '':

    lineRead = lineRead.replace('n', '').split('\t')
    data.append(lineRead)
    
    lineRead = cdf.readline()
    

pdf = open('PDF' + fileName, 'w')

i = 0

while i < len(data):

    if (i==0):
        for val in header:
            pdf.write(val + ',')
        pdf.write('\n')
        i = 1
    
    j = 1
    pdf.write(data[i][0] + ',')
    while j < len(header):
        deltaP = (100-float(data[i][0])) - (100-float(data[i-1][0]))
        deltaEPD  = float(data[i][j]) - float(data[i-1][j])
        pdf.write(str(str(deltaEPD/deltaP)[0:6]) + ',')
        print(deltaEPD/deltaP)
        j = j + 1

    pdf.write('\n')
    i = i + 1

