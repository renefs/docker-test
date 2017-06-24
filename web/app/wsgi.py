from flask import Flask
app = Flask(__name__)

print("Loading app")

@app.route('/')
def hello_world():
    return 'Hello, World!'