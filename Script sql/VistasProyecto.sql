-------------- VISTAS

-------HOTELES
CREATE OR ALTER VIEW vw_Hoteles
AS
SELECT  dbo.Establecimiento.cedula_juridica AS ID, dbo.Establecimiento.nombre_hotel AS Hotel, dbo.Establecimiento.provincia AS Provincia, dbo.Establecimiento.canton AS Canton, dbo.Establecimiento.distrito AS Distrito, 
        dbo.Establecimiento.url_web AS Pagina, dbo.Telefono_Establecimiento.numero AS Teléfono
FROM    dbo.Establecimiento INNER JOIN
        dbo.Telefono_Establecimiento ON dbo.Establecimiento.cedula_juridica = dbo.Telefono_Establecimiento.cedula_juridica
GO
-------TIPOS HABITACIONES
CREATE or alter VIEW [dbo].[vw_TiposHabitaciones]
AS
SELECT        id_tipo AS ID, nombre AS Nombre, descripcion AS Descripción, precio AS Precio
FROM            dbo.Tipo_Habitacion
GO
------- HabitacionesINFO
CREATE OR ALTER VIEW [dbo].[vw_HabitacionesInfo]
AS
SELECT        dbo.Establecimiento.nombre_hotel AS Hotel, dbo.Habitacion.id_habitacion AS ID, dbo.Tipo_Habitacion.nombre AS Habitacion, dbo.Tipo_Habitacion.precio AS Precio, dbo.Habitacion.numero AS [#Habitacion]
FROM            dbo.Establecimiento INNER JOIN
                         dbo.Habitacion ON dbo.Establecimiento.cedula_juridica = dbo.Habitacion.cedula_juridica INNER JOIN
                         dbo.Tipo_Habitacion ON dbo.Habitacion.id_tipo = dbo.Tipo_Habitacion.id_tipo
GO
------- HabitacionesDisponibles
CREATE OR ALTER VIEW [dbo].[vw_HabitacionDisponible]
AS
SELECT        dbo.Establecimiento.nombre_hotel AS Hotel, dbo.Habitacion.id_habitacion AS IDHabitacion, dbo.Tipo_Habitacion.nombre AS Habitacion, dbo.Habitacion.numero AS [#Habitacion], dbo.Habitacion.estado AS Estado
FROM            dbo.Habitacion INNER JOIN
                         dbo.Tipo_Habitacion ON dbo.Habitacion.id_tipo = dbo.Tipo_Habitacion.id_tipo INNER JOIN
                         dbo.Establecimiento ON dbo.Habitacion.cedula_juridica = dbo.Establecimiento.cedula_juridica
GO
------ Clientes
CREATE OR ALTER VIEW [dbo].[vw_Clientes]
AS
SELECT        dbo.Cliente.identificacion AS Identificación, dbo.Cliente.nombre + '  ' + dbo.Cliente.apellidos AS [Nombre Completo], DATEDIFF(YEAR, dbo.Cliente.fecha_nacimiento, GETDATE()) AS Edad, dbo.Telefono_Cliente.numero AS Número,
                          dbo.Cliente.correo AS [Correo Electrónico]
FROM            dbo.Cliente INNER JOIN
                         dbo.Telefono_Cliente ON dbo.Cliente.identificacion = dbo.Telefono_Cliente.identificacion
GO
------ Reservas
CREATE OR ALTER VIEW [dbo].[vw_Reservas]
AS
SELECT        dbo.Reservacion.id_reserva AS IdReserva, dbo.Establecimiento.nombre_hotel AS Hotel, dbo.Tipo_Habitacion.nombre AS Habitacion, dbo.Habitacion.numero AS [#Habitacion], 
                         dbo.Cliente.nombre + N' ' + dbo.Cliente.apellidos AS NombreCliente, dbo.Cliente.identificacion AS IdentificacionCliente, dbo.Reservacion.fecha_hora_ingreso AS [Fecha Ingreso], dbo.Reservacion.fecha_salida AS [Fecha Salida], 
                         dbo.Reservacion.cantidad_personas AS CantidadPersonas
FROM            dbo.Reservacion INNER JOIN
                         dbo.Cliente ON dbo.Reservacion.identificacion = dbo.Cliente.identificacion INNER JOIN
                         dbo.Habitacion ON dbo.Reservacion.id_habitacion = dbo.Habitacion.id_habitacion INNER JOIN
                         dbo.Tipo_Habitacion ON dbo.Habitacion.id_tipo = dbo.Tipo_Habitacion.id_tipo CROSS JOIN
                         dbo.Establecimiento
GO
------ Facturas
CREATE OR ALTER VIEW [dbo].[vw_Factura]
AS
SELECT        dbo.Factura.id_factura AS Factura, dbo.Factura.id_reserva AS Reserva, dbo.Establecimiento.nombre_hotel AS Hotel, dbo.Cliente.nombre + ' ' + dbo.Cliente.apellidos AS NombreCliente, 
                         dbo.Cliente.identificacion AS IdentificacionCliente, dbo.Factura.cargos_habitacion AS Cargos, dbo.Factura.numero_noches AS [Cantidad de Noches], dbo.Factura.fecha_hora_registro AS [Fecha Registro], 
                         dbo.Factura.total AS Total, dbo.Factura.metodo_pago AS [Método de Pago]
FROM            dbo.Factura CROSS JOIN
                         dbo.Cliente CROSS JOIN
                         dbo.Establecimiento
GO
------ REPORTE 
CREATE OR ALTER VIEW dbo.vw_ReporteBase
AS
SELECT
    
    f.id_factura,f.id_reserva,h.id_habitacion,th.id_tipo AS id_tipo_habitacion,e.cedula_juridica,c.identificacion AS identificacion_cliente,
    f.fecha_hora_registro AS fecha_factura,
    r.fecha_hora_ingreso AS fecha_ingreso,
    r.fecha_salida AS fecha_salida,
    YEAR(f.fecha_hora_registro) AS anio,
    MONTH(f.fecha_hora_registro) AS mes,
    DAY(f.fecha_hora_registro) AS dia,

    
    e.nombre_hotel,
    e.provincia,
    e.canton,
    e.distrito,

    
    h.numero AS numero_habitacion,
    th.nombre AS tipo_habitacion,
    th.precio AS precio_habitacion,

    
    DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE())
    - CASE
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()), c.fecha_nacimiento) > GETDATE()
        THEN 1 ELSE 0
      END AS edad_cliente,
    r.cantidad_personas,
    f.cargos_habitacion,
    f.numero_noches,
    f.total,
    f.metodo_pago

FROM dbo.Factura f
JOIN dbo.Reservacion r ON f.id_reserva = r.id_reserva
JOIN dbo.Cliente c ON r.identificacion = c.identificacion
JOIN dbo.Habitacion h ON r.id_habitacion = h.id_habitacion
JOIN dbo.Tipo_Habitacion th ON h.id_tipo = th.id_tipo
JOIN dbo.Establecimiento e ON h.cedula_juridica = e.cedula_juridica;
GO