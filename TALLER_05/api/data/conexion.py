import mariadb
import os
from dotenv import load_dotenv

# Pool de conexiones a la base de datos
try:
    pool = mariadb.ConnectionPool(
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        host=os.getenv('DB_HOST'),
        port=int(os.getenv('DB_PORT', 3306)),
        database=os.getenv('DB_NAME'),
        pool_name="pool_api_proveedores",
        pool_size=5
    )
    print("Pool de conexiones creado exitosamente.")
except mariadb.Error as e:
    print(f"Error al crear el pool de conexiones: {e}")
    pool = None

def get_connection():
    """ Obtiene una conexión del pool de conexiones. """
    # Verificar si el pool fue creado exitosamente
    if pool is None:
        raise Exception("El pool de conexiones no está disponible.")
    
    # Obtener una conexión del pool
    try:
        conn = pool.get_connection()
        return conn
    except mariadb.Error as e:
        print(f"Error al obtener una conexión del pool: {e}")
        return None