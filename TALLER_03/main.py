from flask import Flask, request, jsonify
from datos.conexion import *

app = Flask(__name__)

@app.route('/')
def home():
    info = (get_entity("proveedor"))
    return jsonify(info)

if __name__ == "__main__":
    app.run(debug=True)