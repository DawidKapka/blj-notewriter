import easyocr
import csv
import os
import matplotlib.pyplot as plt

def detectImage(PATH):
    reader = easyocr.Reader(['ch_sim', 'en'], gpu=False)
    result = reader.readtext(PATH, detail=0)

    print(result)

    PATH = 'output.csv'
    file = open(PATH, 'w')
    with file:
        writer = csv.writer(file)
        writer.writerow(result)
detectImage()
