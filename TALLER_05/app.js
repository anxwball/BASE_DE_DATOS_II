const API = 'http://localhost:5000';
let editandoId = null;
let copiaOriginal = {};

function cargarProveedores() {
    fetch(API + '/')
        .then(r => r.json())
        .then(data => {
            const tbody = document.querySelector('#tabla tbody');
            tbody.innerHTML = '';
            data.forEach(p => {
                const tr = document.createElement('tr');
                if (editandoId === p[0]) {
                    tr.innerHTML = `
                        <td>${p[0]}</td>
                        <td><input type="text" value="${copiaOriginal.proveedor}" id="prov-${p[0]}"></td>
                        <td>
                            <select id="stat-${p[0]}">
                                <option value="1" ${copiaOriginal.status == 1 ? 'selected' : ''}>1</option>
                                <option value="2" ${copiaOriginal.status == 2 ? 'selected' : ''}>2</option>
                                <option value="3" ${copiaOriginal.status == 3 ? 'selected' : ''}>3</option>
                            </select>
                        </td>
                        <td><input type="text" value="${copiaOriginal.ciudad}" id="ciu-${p[0]}"></td>
                        <td>
                            <button onclick="guardarEdicion(${p[0]})">Guardar</button>
                            <button onclick="cancelarEdicion()">Cancelar</button>
                        </td>
                    `;
                } else {
                    tr.innerHTML = `
                        <td>${p[0]}</td>
                        <td>${p[1]}</td>
                        <td>${p[2]}</td>
                        <td>${p[3]}</td>
                        <td>
                            <button onclick="editarProveedor(${p[0]}, '${p[1]}', '${p[2]}', '${p[3]}')">Editar</button>
                            <button onclick="eliminarProveedor(${p[0]})">Eliminar</button>
                        </td>
                    `;
                }
                tbody.appendChild(tr);
            });
        });
}

function agregarProveedor() {
    const proveedor = document.getElementById('nuevoProveedor').value;
    const status = document.getElementById('nuevoStatus').value;
    const ciudad = document.getElementById('nuevaCiudad').value;
    if (!proveedor || !status || !ciudad) return alert('Completa todos los campos');
    fetch(API + '/proveedores', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ proveedor, status, ciudad })
    }).then(() => {
        document.getElementById('nuevoProveedor').value = '';
        document.getElementById('nuevoStatus').value = '';
        document.getElementById('nuevaCiudad').value = '';
        cargarProveedores();
    });
}

function editarProveedor(id, proveedor, status, ciudad) {
    editandoId = id;
    copiaOriginal = { proveedor, status, ciudad };
    cargarProveedores();
}

function guardarEdicion(id) {
    const proveedor = document.getElementById(`prov-${id}`).value;
    const status = document.getElementById(`stat-${id}`).value;
    const ciudad = document.getElementById(`ciu-${id}`).value;
    fetch(API + `/proveedores/${id}`, {
        method: 'PUT',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ proveedor, status, ciudad })
    }).then(() => {
        editandoId = null;
        copiaOriginal = {};
        cargarProveedores();
    });
}

function cancelarEdicion() {
    editandoId = null;
    copiaOriginal = {};
    cargarProveedores();
}

function eliminarProveedor(id) {
    if (!confirm('¿Eliminar proveedor?')) return;
    fetch(API + `/proveedores/${id}`, { method: 'DELETE' })
        .then(() => cargarProveedores());
}

cargarProveedores();
