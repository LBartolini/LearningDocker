from flask import Flask
import mysql.connector

app = Flask(__name__)

mydb = mysql.connector.connect(
  host="localhost",
  user="yourusername",
  password="yourpassword"
)

@app.route("/")
def hello_world():
    print(mydb)
    return "<p>Hello, World!</p>"