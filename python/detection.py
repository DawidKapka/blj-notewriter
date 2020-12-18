import easyocr
from flask import Flask
import requests
import os
import shutil

app = Flask(__name__)

@app.route('/result')
def detectImage():
    PIC_PATH = 'image_for_detection/image.jpg'

    response = requests.get("http://www.041er-blj.ch/2020/dakapka/notewriter/image.jpg", stream=True)
    file = open(PIC_PATH, "wb")
    response.raw.decode_content = True
    shutil.copyfileobj(response.raw, file)
    del response

    reader = easyocr.Reader(['ch_sim', 'en'], gpu=False)
    result = reader.readtext(PIC_PATH, detail=0)

    print(result)

    result_string = ''
    for word in result:
       result_string += word + ' '

    print(result_string)
    return result_string

app.run()

