import mariadb

# conn = mariadb.connect(
#     user = "root",
#     password = "Eliel120104-a",
#     host = "127.0.0.1",
#     port = 3306,
#     database = "practica"
# )

# cursor = conn.cursor()

# query = """ CREATE OR REPLACE TABLE proveedor (
#     id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
#     proveedor VARCHAR(10),
#     status INT,
#     ciudad VARCHAR (150)
# ); """

# cursor.execute(query)

# queryFull = "INSERT INTO proveedor VALUES(null,'Prov#21',3,'Chiriqui')"
# queryFull1 = "INSERT INTO proveedor VALUES(null,'Prov#45',2,'Panama')"
# queryFull2 = "INSERT INTO proveedor VALUES(null,'Prov#67',1,'Los Santos')"

# cursor.execute(queryFull)
# cursor.execute(queryFull1)
# cursor.execute(queryFull2)

# conn.commit()

# Mini Menú
# print("\t++++++Menú Crear Proveedor++++++\n")
# proveedor = input("Inserte el nombre del proveedor: ")
# status = int(input("\nInserte el estatus: "))
# ciudad = input("\nInserte la ciudad: ")

# valores = (proveedor, status, ciudad)

# query = "INSERT INTO proveedor VALUES (null, ?, ?, ?)"
# cursor.execute(query, valores)
# conn.commit()

# cursor.execute("SELECT * FROM proveedor")
# result = cursor.fetchall()
# print(result)
# conn.commit()

# cursor.execute("SELECT * FROM proveedor")
# print(cursor.fetchall())
# conn.commit()
# data = []

# for item in data:
#     id = item[0]
#     name = item[1]
#     city = item[2]

#     lista = {
#         "ID": id,
#         "Nombre": name,
#         "Ciudad": city,
#     }

#     print(lista)

#     data.append(lista)
    
#     conn.close()

# def mostrar_data():
    
#     conexion = mariadb.connect(user = "root", password = "Eliel120104-a", host = "127.0.0.1", port = 3306, database = "practica")
#     cursor = conexion.cursor()

#     cursor.execute("SELECT * FROM proveedor")
#     data = []

#     for item in data:
#         id = item[0]
#         name = item[1]
#         city = item[2]

#         lista = {
#             "ID": id,
#             "Nombre": name,
#             "Ciudad": city,
#         }

#         print(lista)

#         data.append(lista)
        
#         conn.close()