import easyocr
import time
from flask import Flask
import requests
import os
import shutil
from PIL import ImageFile

app = Flask(__name__)

@app.route('/')
def detectImage():
    try:
        time.sleep(0.5)
        ImageFile.LOAD_TRUNCATED_IMAGES = True
        PIC_PATH = 'image_for_detection/image.jpg'

        response = requests.get("http://www.041er-blj.ch/2020/dakapka/notewriter/image.jpg", stream=True)
        file = open(PIC_PATH, "wb")
        response.raw.decode_content = True
        shutil.copyfileobj(response.raw, file)
        del response

        reader = easyocr.Reader(['en', 'de'], gpu=False)
        result = reader.readtext(PIC_PATH, detail=0)

        print(result)

        result_string = ''
        for word in result:
            result_string += word + ' '
        print(result_string)
        os.remove('image_for_detection/image.jpg')
        return result_string
    except:
        return 'Oops! Seems like there was an Error.\nPlease Try again.'




