import easyocr
import csv
import os
from flask import *


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

    return result_string
app.run()

