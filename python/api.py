from flask import Flask
from flask_restful import Resource, Api
import os
import detection

app = Flask(__name__)
api = Api(app)

#work in progress