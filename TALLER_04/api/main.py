from flask import Flask, jsonify, request
from datos.conn import *

app = Flask(__name__)

# Pantalla de inicio de sesión
@app.route('/login', methods=['POST'])
def login():
    cursor = None
    try:
        data = request.json

        if not data:
            return jsonify({"mensaje": "Datos inválidos"}), 400

        usuario = data.get('usuario')
        contrasena = data.get('contrasena')

        if not usuario or not contrasena:
            return jsonify({"mensaje": "Usuario y contraseña requeridos"}), 400

        cursor = get_cursor()
        query = "SELECT id_usuario, nombre_usuario, rol_usuario FROM usuarios WHERE nombre_usuario = %s AND contrasena_usuario = %s"
        cursor.execute(query, (usuario, contrasena))

        resultado = cursor.fetchone()
        
        if resultado:
            return jsonify({
                "mensaje": "Login exitoso",
                "usuario": {
                    "id": resultado[0],
                    "nombre": resultado[1],
                    "rol": resultado[2]
                }
            }), 200
        else: 
            return jsonify({"mensaje": "Credenciales inválidas"}), 401
    
    except Exception as e:
        print(f"Error en login: {str(e)}")
        return jsonify({"mensaje": f"Error: {str(e)}"}), 500
    
    finally:
        if cursor:
            cursor.close()

# Pantalla de menú de agenda de expedientes
@app.route('/expedientes')
def obtener_agenda_diaria():
    cursor = None
    try:
        fecha = request.args.get('fecha')
        cursor = get_cursor()

        base = """
            SELECT 
                nombre_aseguradora,
                CONCAT(nombre_asegurado, ' ', apellido_asegurado) AS asegurado,
                nombre_juzgado
            FROM vista_agenda_diaria
        """
        params = ()
        if fecha:
            base += " WHERE DATE(fecha_creacion) = %s"
            params = (fecha,)
        base += " ORDER BY fecha_creacion DESC"

        cursor.execute(base, params)
        filas = cursor.fetchall()

        lista = [{"aseguradora": r[0], "asegurado": r[1], "juzgado": r[2]} for r in filas]

        if lista:
            return jsonify({"lista": lista, "total": len(lista)}), 200
        else:
            return jsonify({"mensaje": "Sin registros"}), 404
    except Exception as e:
        print(f"Error en expedientes: {str(e)}")
        return jsonify({"mensaje": f"Error: {str(e)}"}), 500
    finally:
        if cursor:
            cursor.close()


if __name__ == '__main__':
    app.run(debug=True)