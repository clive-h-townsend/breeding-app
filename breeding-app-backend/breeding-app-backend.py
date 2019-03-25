import firebase_admin
from firebase_admin import credentials, firestore

import csv


cred = credentials.Certificate('./ServiceAccountKey.json')

firebase_admin.initialize_app(cred)

db = firestore.client()

collection_ref = db.collection(u'animals')

dataFile = open('animals2.csv')

lineRead = dataFile.readline().replace('"', '').replace('(', '').replace(')', '').replace('\n', '')
headers = lineRead.split(',')
lineRead = dataFile.readline().replace('"', '').replace('(', '').replace(')', '').replace('\n', '')

while lineRead != '':
    
    values = lineRead.split(',')

    animalObject = {}

    for i in range(len(headers)):
        animalObject[headers[i]] = values[i]
        
    print(animalObject['ASA Number'])
    doc_ref = db.collection(u'animals').document(animalObject['ASA Number'])
    doc_ref.set(animalObject, merge=True)
    lineRead = dataFile.readline().replace('"', '').replace('(', '').replace(')', '').replace('\n', '')

