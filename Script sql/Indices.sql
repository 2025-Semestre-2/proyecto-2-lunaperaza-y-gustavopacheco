CREATE NONCLUSTERED INDEX Ind_Reservacion_Habitacion_Fechas
ON Reservacion (id_habitacion, fecha_hora_ingreso, fecha_salida);
GO

CREATE NONCLUSTERED INDEX Ind_Factura_Fecha
ON Factura (fecha_hora_registro);
GO

CREATE NONCLUSTERED INDEX Ind_Habitacion_Tipo
ON Habitacion (id_tipo);
GO

CREATE NONCLUSTERED INDEX Ind_TipoHabitacion_Precio
ON Tipo_Habitacion (precio);
GO

CREATE NONCLUSTERED INDEX Ind_Cliente_FechaNacimiento
ON Cliente (fecha_nacimiento);
GO
