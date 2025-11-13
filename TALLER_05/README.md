# TALLER 05 - API CRUD de Proveedores

## Descripción

Este proyecto implementa un sistema CRUD (Create, Read, Update, Delete) para la gestión de proveedores, utilizando una API desarrollada en Python (Flask) y una SPA (Single Page Application) en HTML y JavaScript puro.

### I PARTE: CRUD de Proveedores

- **Insertar (POST):** Agrega un nuevo proveedor mediante una petición POST a la API.
- **Consultar (GET):** Lista todos los proveedores mediante una petición GET.
- **Editar (PUT):** Permite modificar la información de un proveedor mediante una petición PUT.
- **Eliminar (DELETE):** Elimina proveedores mediante una petición DELETE.

La base de datos utilizada es la de proveedores vista en clase, conectada mediante MariaDB y gestionada con un pool de conexiones.

### II PARTE: Caso de Uso

#### Dashboard administrativo

El área de administración cuenta con un panel para visualizar y gestionar proveedores.

**Características del dashboard:**

- Visualiza la lista de proveedores (GET).
- Permite agregar proveedores desde un formulario (POST).
- Permite editar información directamente en la tabla (PUT).
- Permite eliminar registros obsoletos (DELETE).

La SPA está implementada en `index.html` y `app.js`, mostrando una tabla editable y un formulario para agregar proveedores.

---

## Estructura del Proyecto

```
.env        # Archivo de variables de entorno (NO debe subirse al repositorio)
app.js
index.html
README.md
requirements.txt
styles.css
api/
    main.py
    data/
        conexion.py
```

- **api/main.py:** API RESTful con Flask para operaciones CRUD.
- **api/data/conexion.py:** Manejo de pool de conexiones a la base de datos MariaDB.
- **index.html, app.js, styles.css:** SPA para la gestión visual de proveedores.

> **Nota:** El archivo `.env` contiene información sensible y **no debe ser subido al repositorio**. Inclúyelo en tu `.gitignore`.

---

## Variables de entorno

El archivo `.env` contiene las variables necesarias para la conexión a la base de datos. Estas variables son leídas en [`api/data/conexion.py`](api/data/conexion.py) y utilizadas por la API en [`api/main.py`](api/main.py) para establecer la conexión con MariaDB.

**Ejemplo de archivo `.env`:**

```
DB_USER=usuario
DB_PASSWORD=contraseña
DB_HOST=localhost
DB_PORT=3306
DB_NAME=nombre_base_de_datos
```

**Descripción de cada variable:**

- `DB_USER`: Usuario de la base de datos MariaDB.
- `DB_PASSWORD`: Contraseña del usuario de la base de datos.
- `DB_HOST`: Host donde se encuentra la base de datos (usualmente `localhost`).
- `DB_PORT`: Puerto de conexión (por defecto `3306`).
- `DB_NAME`: Nombre de la base de datos a utilizar.

> **Importante:**
> Modifica estos valores en el archivo `.env` para que coincidan con la configuración de tu entorno de base de datos.
> **No subas el archivo `.env` al repositorio**.

---

## Instrucciones para ejecutar

1. Configura las variables de entorno en `.env` con los datos de tu base de datos.
2. Instala las dependencias necesarias ejecutando:

   ```
   pip install -r requirements.txt
   ```

3. Ejecuta la API con:

   ```
   python api/main.py
   ```

4. Abre `index.html` en tu navegador para acceder al dashboard administrativo.

---

## Autor

Aaron Newball
