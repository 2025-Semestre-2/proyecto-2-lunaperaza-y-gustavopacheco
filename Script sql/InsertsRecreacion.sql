INSERT INTO Empresa_Recreacion
(nombre, cedula_juridica, correo, nombre_contacto,
 provincia, canton, distrito, señas_exactas, precio)
VALUES
('Aventuras del Caribe',
 '3-101-999999',
 'info@aventurascr.com',
 'Juan Pérez',
 'Limón',
 'Pococí',
 'Guápiles',
 '200 metros norte del parque',
 25000);

INSERT INTO Tipo_Actividad (nombre)
VALUES
('Tour en bote'),
('Tour en lancha'),
('Tour en catamarán'),
('Kayak'),
('Transporte');

 INSERT INTO Telefono_Empresa_Recreacion
(id_empresa_recreacion, codigo_pais, telefono)
VALUES
(1, '+506', '8888-9999'),
(1, '+506', '2222-3333');

INSERT INTO Empresa_Actividad
(id_empresa_recreacion, id_tipo_actividad)
VALUES
(1, 1), -- Tour en bote
(1, 4); -- Kayak

INSERT INTO Servicio_Recreacion (nombre, descripcion)
VALUES
('Tour por manglares', 'Recorrido guiado por manglares'), --nombre unique key
('Kayak guiado', 'Kayak con instructor certificado');

INSERT INTO Empresa_Servicio_Recreacion
(id_empresa_recreacion, id_servicio)
VALUES
(1, 1),
(1, 2);

SELECT DISTINCT
    e.nombre,
    e.provincia,
    e.canton,
    e.distrito,
    e.precio,
    ta.nombre AS tipo_actividad,
    s.nombre AS servicio
FROM Empresa_Recreacion e
JOIN Empresa_Actividad ea
    ON e.id_empresa_recreacion = ea.id_empresa_recreacion
JOIN Tipo_Actividad ta
    ON ea.id_tipo_actividad = ta.id_tipo_actividad
JOIN Empresa_Servicio_Recreacion es
    ON e.id_empresa_recreacion = es.id_empresa_recreacion
JOIN Servicio_Recreacion s
    ON es.id_servicio = s.id_servicio
WHERE 1 = 1;

SELECT DISTINCT e.nombre, e.precio, ta.nombre AS actividad
FROM Empresa_Recreacion e
JOIN Empresa_Actividad ea ON e.id_empresa_recreacion = ea.id_empresa_recreacion
JOIN Tipo_Actividad ta ON ea.id_tipo_actividad = ta.id_tipo_actividad
WHERE e.provincia = 'Limón'
AND ta.nombre = 'Tour en bote'
AND e.precio <= 30000;