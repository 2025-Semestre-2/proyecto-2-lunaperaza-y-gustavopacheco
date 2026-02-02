USE ProyectoVerano;
GO

-- ===== A) CATÁLOGOS =====
IF NOT EXISTS (SELECT 1 FROM Servicio_Hospedaje WHERE nombre_servicio='WiFi')
  INSERT INTO Servicio_Hospedaje(nombre_servicio) VALUES ('WiFi');
IF NOT EXISTS (SELECT 1 FROM Servicio_Hospedaje WHERE nombre_servicio='Piscina')
  INSERT INTO Servicio_Hospedaje(nombre_servicio) VALUES ('Piscina');
IF NOT EXISTS (SELECT 1 FROM Servicio_Hospedaje WHERE nombre_servicio='Parqueo')
  INSERT INTO Servicio_Hospedaje(nombre_servicio) VALUES ('Parqueo');

IF NOT EXISTS (SELECT 1 FROM Comodidad WHERE nombre_comodidad='A/C')
  INSERT INTO Comodidad(nombre_comodidad) VALUES ('A/C');
IF NOT EXISTS (SELECT 1 FROM Comodidad WHERE nombre_comodidad='Agua caliente')
  INSERT INTO Comodidad(nombre_comodidad) VALUES ('Agua caliente');
IF NOT EXISTS (SELECT 1 FROM Comodidad WHERE nombre_comodidad='TV')
  INSERT INTO Comodidad(nombre_comodidad) VALUES ('TV');

-- ===== B) ESTABLECIMIENTO =====
IF NOT EXISTS (SELECT 1 FROM Establecimiento WHERE cedula_juridica='3-101-000000')
BEGIN
  INSERT INTO Establecimiento (
    cedula_juridica, nombre_hotel, tipo,
    provincia, canton, distrito, barrio, senas,
    gps_lat, gps_lon, correo, url_web
  ) VALUES (
    '3-101-000000', 'Hotel Prueba', 'Hotel',
    'San José', 'Central', 'Carmen', 'Barrio X', '200m norte del parque',
    9.9333000, -84.0833000, 'contacto@hotelprueba.com', 'https://hotelprueba.com'
  );
END

IF NOT EXISTS (SELECT 1 FROM Telefono_Establecimiento WHERE cedula_juridica='3-101-000000' AND numero='8888-8888')
  INSERT INTO Telefono_Establecimiento (cedula_juridica, codigo_pais, numero)
  VALUES ('3-101-000000', '+506', '8888-8888');

IF NOT EXISTS (SELECT 1 FROM RedSocial_Establecimiento WHERE cedula_juridica='3-101-000000' AND red='Instagram')
  INSERT INTO RedSocial_Establecimiento (cedula_juridica, red, url)
  VALUES ('3-101-000000', 'Instagram', 'https://instagram.com/hotelprueba');

-- servicios ofrecidos (sin subquery múltiple)
DECLARE @wifi INT = (SELECT MIN(id_servicio) FROM Servicio_Hospedaje WHERE nombre_servicio='WiFi');
DECLARE @parq INT = (SELECT MIN(id_servicio) FROM Servicio_Hospedaje WHERE nombre_servicio='Parqueo');

IF NOT EXISTS (SELECT 1 FROM Establecimiento_Servicio WHERE cedula_juridica='3-101-000000' AND id_servicio=@wifi)
  INSERT INTO Establecimiento_Servicio (cedula_juridica, id_servicio) VALUES ('3-101-000000', @wifi);

IF NOT EXISTS (SELECT 1 FROM Establecimiento_Servicio WHERE cedula_juridica='3-101-000000' AND id_servicio=@parq)
  INSERT INTO Establecimiento_Servicio (cedula_juridica, id_servicio) VALUES ('3-101-000000', @parq);

-- ===== C) TIPOS =====
IF NOT EXISTS (SELECT 1 FROM Tipo_Habitacion WHERE nombre='Estándar')
  INSERT INTO Tipo_Habitacion (nombre, descripcion, tipo_cama, precio)
  VALUES ('Estándar', 'Habitación estándar', 'Queen', 45000.00);

IF NOT EXISTS (SELECT 1 FROM Tipo_Habitacion WHERE nombre='Suite')
  INSERT INTO Tipo_Habitacion (nombre, descripcion, tipo_cama, precio)
  VALUES ('Suite', 'Suite con sala', 'King', 80000.00);

DECLARE @tipoE INT = (SELECT MIN(id_tipo) FROM Tipo_Habitacion WHERE nombre='Estándar');
DECLARE @tipoS INT = (SELECT MIN(id_tipo) FROM Tipo_Habitacion WHERE nombre='Suite');

IF NOT EXISTS (SELECT 1 FROM Establecimiento_Tipo_Habitacion WHERE cedula_juridica='3-101-000000' AND id_tipo=@tipoE)
  INSERT INTO Establecimiento_Tipo_Habitacion (cedula_juridica, id_tipo, cantidad_de_ese_tipo)
  VALUES ('3-101-000000', @tipoE, 10);

IF NOT EXISTS (SELECT 1 FROM Establecimiento_Tipo_Habitacion WHERE cedula_juridica='3-101-000000' AND id_tipo=@tipoS)
  INSERT INTO Establecimiento_Tipo_Habitacion (cedula_juridica, id_tipo, cantidad_de_ese_tipo)
  VALUES ('3-101-000000', @tipoS, 3);

IF NOT EXISTS (SELECT 1 FROM Foto_Tipo_Habitacion WHERE id_tipo=@tipoE AND url_foto='https://ejemplo.com/estandar1.jpg')
  INSERT INTO Foto_Tipo_Habitacion (id_tipo, url_foto) VALUES (@tipoE, 'https://ejemplo.com/estandar1.jpg');

IF NOT EXISTS (SELECT 1 FROM Foto_Tipo_Habitacion WHERE id_tipo=@tipoS AND url_foto='https://ejemplo.com/suite1.jpg')
  INSERT INTO Foto_Tipo_Habitacion (id_tipo, url_foto) VALUES (@tipoS, 'https://ejemplo.com/suite1.jpg');

DECLARE @ac INT   = (SELECT MIN(id_comodidad) FROM Comodidad WHERE nombre_comodidad='A/C');
DECLARE @agua INT = (SELECT MIN(id_comodidad) FROM Comodidad WHERE nombre_comodidad='Agua caliente');
DECLARE @tv INT   = (SELECT MIN(id_comodidad) FROM Comodidad WHERE nombre_comodidad='TV');

IF NOT EXISTS (SELECT 1 FROM TipoHabitacion_Comodidad WHERE id_tipo=@tipoE AND id_comodidad=@agua)
  INSERT INTO TipoHabitacion_Comodidad (id_tipo, id_comodidad) VALUES (@tipoE, @agua);

IF NOT EXISTS (SELECT 1 FROM TipoHabitacion_Comodidad WHERE id_tipo=@tipoE AND id_comodidad=@tv)
  INSERT INTO TipoHabitacion_Comodidad (id_tipo, id_comodidad) VALUES (@tipoE, @tv);

IF NOT EXISTS (SELECT 1 FROM TipoHabitacion_Comodidad WHERE id_tipo=@tipoS AND id_comodidad=@ac)
  INSERT INTO TipoHabitacion_Comodidad (id_tipo, id_comodidad) VALUES (@tipoS, @ac);

IF NOT EXISTS (SELECT 1 FROM TipoHabitacion_Comodidad WHERE id_tipo=@tipoS AND id_comodidad=@agua)
  INSERT INTO TipoHabitacion_Comodidad (id_tipo, id_comodidad) VALUES (@tipoS, @agua);

IF NOT EXISTS (SELECT 1 FROM TipoHabitacion_Comodidad WHERE id_tipo=@tipoS AND id_comodidad=@tv)
  INSERT INTO TipoHabitacion_Comodidad (id_tipo, id_comodidad) VALUES (@tipoS, @tv);

-- ===== D) HABITACIONES =====
IF NOT EXISTS (SELECT 1 FROM Habitacion WHERE cedula_juridica='3-101-000000' AND numero=101)
  INSERT INTO Habitacion (cedula_juridica, id_tipo, numero, estado)
  VALUES ('3-101-000000', @tipoE, 101, 'Activo');

-- ===== E) CLIENTE =====
IF NOT EXISTS (SELECT 1 FROM Cliente WHERE identificacion='119010160')
BEGIN
  INSERT INTO Cliente (
    identificacion, tipo_identificacion, nombre, apellidos,
    fecha_nacimiento, pais_residencia, provincia_cr, canton_cr, distrito_cr, correo
  ) VALUES (
    '119010160', 'Cédula', 'Maria', 'Campos Vargas',
    '2002-05-10', 'Costa Rica', 'San José', 'Central', 'Carmen', 'maria@email.com'
  );
END

IF NOT EXISTS (SELECT 1 FROM Telefono_Cliente WHERE identificacion='119010160' AND numero='8777-7777')
  INSERT INTO Telefono_Cliente (identificacion, codigo_pais, numero)
  VALUES ('119010160', '+506', '8777-7777');

-- ===== F) RESERVACION + FACTURA =====
DECLARE @idHab INT = (
  SELECT MIN(id_habitacion) FROM Habitacion
  WHERE cedula_juridica='3-101-000000' AND numero=101
);

IF NOT EXISTS (
  SELECT 1 FROM Reservacion
  WHERE identificacion='119010160' AND id_habitacion=@idHab
)
BEGIN
  INSERT INTO Reservacion (
    identificacion, id_habitacion, fecha_hora_ingreso,
    cantidad_personas, posee_vehiculo, fecha_salida
  ) VALUES (
    '119010160', @idHab, '2025-12-28 14:00:00',
    2, 1, '2025-12-30 11:00:00'
  );
END

DECLARE @idRes INT = (SELECT MAX(id_reserva) FROM Reservacion);

IF NOT EXISTS (SELECT 1 FROM Factura WHERE id_reserva=@idRes)
BEGIN
  INSERT INTO Factura (
    id_reserva, cargos_habitacion, numero_noches, total,
    metodo_pago, fecha_hora_registro
  ) VALUES (
    @idRes, 90000.00, 2, 90000.00,
    'Tarjeta', '2025-12-30 11:05:00'
  );
END
GO



EXEC sp_help 'NombreDeLaTabla';

USE ProyectoVerano;
GO

DECLARE @tipoE INT = (SELECT MIN(id_tipo) FROM Tipo_Habitacion WHERE nombre='Estándar');
DECLARE @tipoS INT = (SELECT MIN(id_tipo) FROM Tipo_Habitacion WHERE nombre='Suite');

IF NOT EXISTS (SELECT 1 FROM Habitacion WHERE cedula_juridica='3-101-000000' AND numero=102)
  INSERT INTO Habitacion (cedula_juridica, id_tipo, numero, estado)
  VALUES ('3-101-000000', @tipoE, 102, 'Activo');

IF NOT EXISTS (SELECT 1 FROM Habitacion WHERE cedula_juridica='3-101-000000' AND numero=201)
  INSERT INTO Habitacion (cedula_juridica, id_tipo, numero, estado)
  VALUES ('3-101-000000', @tipoS, 201, 'Activo');
GO


SELECT COUNT(*) AS CantHab FROM Habitacion;
GO


---prueba borrar datos en orden correcto 
USE ProyectoVerano;
GO

-- BORRAR HIJAS primero (por FK)
DELETE FROM Factura;
DELETE FROM Reservacion;

DELETE FROM Telefono_Cliente;

DELETE FROM Habitacion;
DELETE FROM TipoHabitacion_Comodidad;
DELETE FROM Foto_Tipo_Habitacion;
DELETE FROM Establecimiento_Tipo_Habitacion;

DELETE FROM Establecimiento_Servicio;
DELETE FROM RedSocial_Establecimiento;
DELETE FROM Telefono_Establecimiento;

-- tablas base
DELETE FROM Cliente;
DELETE FROM Tipo_Habitacion;
DELETE FROM Comodidad;
DELETE FROM Servicio_Hospedaje;
DELETE FROM Establecimiento;
GO


--- pruebas 

USE ProyectoVerano;
GO

SELECT COUNT(*) AS CantEst FROM Establecimiento;
SELECT COUNT(*) AS CantServ FROM Servicio_Hospedaje;
SELECT COUNT(*) AS CantComod FROM Comodidad;
SELECT COUNT(*) AS CantTipo FROM Tipo_Habitacion;
SELECT COUNT(*) AS CantHab FROM Habitacion;
SELECT COUNT(*) AS CantCli FROM Cliente;
SELECT COUNT(*) AS CantRes FROM Reservacion;
SELECT COUNT(*) AS CantFact FROM Factura;
GO


--- pruebas para capturas 

-- Hotel + teléfonos
SELECT e.nombre_hotel, t.codigo_pais, t.numero
FROM Establecimiento e
JOIN Telefono_Establecimiento t ON t.cedula_juridica = e.cedula_juridica;

-- Tipos y cantidad por hotel
SELECT e.nombre_hotel, th.nombre AS tipo_habitacion, eth.cantidad_de_ese_tipo, th.precio
FROM Establecimiento e
JOIN Establecimiento_Tipo_Habitacion eth ON eth.cedula_juridica = e.cedula_juridica
JOIN Tipo_Habitacion th ON th.id_tipo = eth.id_tipo;

-- Reservación + cliente + habitación
SELECT c.nombre, c.apellidos, r.id_reserva, h.numero AS num_habitacion, r.fecha_hora_ingreso, r.fecha_salida
FROM Reservacion r
JOIN Cliente c ON c.identificacion = r.identificacion
JOIN Habitacion h ON h.id_habitacion = r.id_habitacion;

-- Factura
SELECT * FROM Factura;

---pruebas para otras capturas 

USE ProyectoVerano;
GO

-- 1) Establecimiento + Teléfonos
SELECT e.cedula_juridica, e.nombre_hotel, t.codigo_pais, t.numero
FROM Establecimiento e
JOIN Telefono_Establecimiento t ON t.cedula_juridica = e.cedula_juridica;

-- 2) Establecimiento + Servicios
SELECT e.nombre_hotel, s.nombre_servicio
FROM Establecimiento e
JOIN Establecimiento_Servicio es ON es.cedula_juridica = e.cedula_juridica
JOIN Servicio_Hospedaje s ON s.id_servicio = es.id_servicio;

-- 3) Establecimiento + Tipo habitación + Cantidad
SELECT e.nombre_hotel, th.nombre AS tipo_habitacion, eth.cantidad_de_ese_tipo, th.precio
FROM Establecimiento e
JOIN Establecimiento_Tipo_Habitacion eth ON eth.cedula_juridica = e.cedula_juridica
JOIN Tipo_Habitacion th ON th.id_tipo = eth.id_tipo;

-- 4) Tipo habitación + comodidades
SELECT th.nombre AS tipo_habitacion, c.nombre_comodidad
FROM Tipo_Habitacion th
JOIN TipoHabitacion_Comodidad thc ON thc.id_tipo = th.id_tipo
JOIN Comodidad c ON c.id_comodidad = thc.id_comodidad
ORDER BY th.nombre;

-- 5) Reservación + cliente + habitación
SELECT r.id_reserva, c.nombre, c.apellidos, h.numero AS habitacion, r.fecha_hora_ingreso, r.fecha_salida
FROM Reservacion r
JOIN Cliente c ON c.identificacion = r.identificacion
JOIN Habitacion h ON h.id_habitacion = r.id_habitacion;

-- 6) Factura
SELECT f.id_factura, f.id_reserva, f.total, f.metodo_pago, f.fecha_hora_registro
FROM Factura f;
GO



--- pruebas extras opcionales 
USE ProyectoVerano;
GO

DECLARE @tipoE INT = (SELECT MIN(id_tipo) FROM Tipo_Habitacion WHERE nombre='Estándar');
DECLARE @tipoS INT = (SELECT MIN(id_tipo) FROM Tipo_Habitacion WHERE nombre='Suite');

IF NOT EXISTS (SELECT 1 FROM Habitacion WHERE cedula_juridica='3-101-000000' AND numero=102)
  INSERT INTO Habitacion (cedula_juridica, id_tipo, numero, estado)
  VALUES ('3-101-000000', @tipoE, 102, 'Activo');

IF NOT EXISTS (SELECT 1 FROM Habitacion WHERE cedula_juridica='3-101-000000' AND numero=201)
  INSERT INTO Habitacion (cedula_juridica, id_tipo, numero, estado)
  VALUES ('3-101-000000', @tipoS, 201, 'Activo');
GO

SELECT COUNT(*) AS CantHab FROM Habitacion;


---pruebas 
USE ProyectoVerano;
GO

-- E1) Establecimiento + Teléfonos
SELECT e.cedula_juridica, e.nombre_hotel, t.codigo_pais, t.numero
FROM Establecimiento e
JOIN Telefono_Establecimiento t ON t.cedula_juridica = e.cedula_juridica;

-- E2) Establecimiento + Servicios
SELECT e.nombre_hotel, s.nombre_servicio
FROM Establecimiento e
JOIN Establecimiento_Servicio es ON es.cedula_juridica = e.cedula_juridica
JOIN Servicio_Hospedaje s ON s.id_servicio = es.id_servicio
ORDER BY e.nombre_hotel, s.nombre_servicio;

-- E3) Establecimiento + Tipo habitación + Cantidad + Precio
SELECT e.nombre_hotel, th.nombre AS tipo_habitacion, eth.cantidad_de_ese_tipo, th.precio
FROM Establecimiento e
JOIN Establecimiento_Tipo_Habitacion eth ON eth.cedula_juridica = e.cedula_juridica
JOIN Tipo_Habitacion th ON th.id_tipo = eth.id_tipo
ORDER BY e.nombre_hotel, th.nombre;

-- E4) Tipo habitación + Comodidades
SELECT th.nombre AS tipo_habitacion, c.nombre_comodidad
FROM Tipo_Habitacion th
JOIN TipoHabitacion_Comodidad thc ON thc.id_tipo = th.id_tipo
JOIN Comodidad c ON c.id_comodidad = thc.id_comodidad
ORDER BY th.nombre, c.nombre_comodidad;

-- E5) Reservación + Cliente + Habitación
SELECT r.id_reserva, c.identificacion, c.nombre, c.apellidos, h.numero AS habitacion,
       r.fecha_hora_ingreso, r.fecha_salida, r.cantidad_personas, r.posee_vehiculo
FROM Reservacion r
JOIN Cliente c ON c.identificacion = r.identificacion
JOIN Habitacion h ON h.id_habitacion = r.id_habitacion;

-- E6) Factura
SELECT f.id_factura, f.id_reserva, f.cargos_habitacion, f.numero_noches, f.total,
       f.metodo_pago, f.fecha_hora_registro
FROM Factura f;
GO
