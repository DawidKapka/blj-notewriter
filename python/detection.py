import easyocr
import csv
import os
from flask import *
import mysql.connector

mydb = mysql.connector.connect(
  host="mysql2.webland.ch",
  user="d041e_dakapka",
  password="12345_Db!!!",
  database="d041e_dakapka"
)
mycursor = mydb.cursor()

app = Flask(__name__)

@app.route('/result')
def detectImage():
    PIC_PATH = 'image_for_detection/image.jpg'
    reader = easyocr.Reader(['ch_sim', 'en'], gpu=False)
    result = reader.readtext(PIC_PATH, detail=0)

    print(result)

    #PATH = 'output.csv'
    #file = open(PATH, 'w')
    #with file:
     #   writer = csv.writer(file)
      #  writer.writerow(result)


    result_string = ''
    for word in result:
       result_string += word + ' '

    print(result_string)
    return result_string

app.run()

