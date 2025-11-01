import mariadb

def get_connection():
    connector = mariadb.connect (
        user = "root",
        password = "Eliel120104-a",
        host = "127.0.0.1",
        port = 3306,
        database = "sistema_expedientes"
    )
    return connector

def get_cursor():
    cursor = get_connection().cursor()
    return cursor

# def get_entity(name):
#     cursor = get_cursor()
#     query = "SELECT * FROM {}".format(name)

#     print("Query: ", query)
#     cursor.execute(query)
#     result = cursor.fetchall()
    
#     return result

# print(get_entity("proveedor"))