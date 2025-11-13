from flask import Flask, request, jsonify
from flask_cors import CORS
from data.conexion import get_connection

app = Flask(__name__)

CORS(app)

# READ
@app.route('/', methods=['GET'])
def get_proveedores():
    conn = get_connection()
    if not conn:
        return jsonify({'error': 'No se pudo conectar a la base de datos'}), 500
    cur = conn.cursor()
    cur.execute("SELECT * FROM proveedor")
    data = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(data)

# CREATE
@app.route('/proveedores', methods=['POST'])
def add_proveedor():
    d = request.json
    if not d or not all(k in d for k in ('proveedor', 'status', 'ciudad')):
        return jsonify({'error': 'Faltan datos requeridos'}), 400
    conn = get_connection()
    if not conn:
        return jsonify({'error': 'No se pudo conectar a la base de datos'}), 500
    cur = conn.cursor()
    cur.execute("INSERT INTO proveedor (proveedor, status, ciudad) VALUES (%s, %s, %s)", (d['proveedor'], d['status'], d['ciudad']))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'ok': True})

# UPDATE
@app.route('/proveedores/<int:id>', methods=['PUT'])
def update_proveedor(id):
    d = request.json
    if not d or not all(k in d for k in ('proveedor', 'status', 'ciudad')):
        return jsonify({'error': 'Faltan datos requeridos'}), 400
    conn = get_connection()
    if not conn:
        return jsonify({'error': 'No se pudo conectar a la base de datos'}), 500
    cur = conn.cursor()
    cur.execute("UPDATE proveedor SET proveedor=%s, status=%s, ciudad=%s WHERE id=%s", (d['proveedor'], d['status'], d['ciudad'], id))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'ok': True})

# DELETE
@app.route('/proveedores/<int:id>', methods=['DELETE'])
def delete_proveedor(id):
    conn = get_connection()
    if not conn:
        return jsonify({'error': 'No se pudo conectar a la base de datos'}), 500
    cur = conn.cursor()
    cur.execute("DELETE FROM proveedor WHERE id=%s", (id,))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'ok': True})

if __name__ == '__main__':
    app.run(debug=True)