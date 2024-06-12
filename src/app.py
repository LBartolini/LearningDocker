from flask import Flask
import mysql.connector as mysql

app = Flask(__name__)

mydb = mysql.connect(
  host="db",
  user="root",
  password="admin"
)

@app.route("/")
def hello_world():
    print(mydb)
    return "<p>Hello, World!</p>"