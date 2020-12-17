import easyocr
from flask import Flask
import requests

app = Flask(__name__)

@app.route('/result')
def detectImage():
    PIC_PATH = 'image_for_detection/image.jpg'

    #response = requests.get("http://139.162.146.78")
    #file = open(PIC_PATH, "wb")
    #file.write(response.content)
    #file.close()

    reader = easyocr.Reader(['ch_sim', 'en'], gpu=False)
    result = reader.readtext(PIC_PATH, detail=0)

    print(result)

    result_string = ''
    for word in result:
       result_string += word + ' '

    print(result_string)
    return result_string

app.run()

