-- ESTABLECIMIENTO / HOTEL

--sp_InsertarEstablecimiento
CREATE OR ALTER PROCEDURE sp_InsertarEstablecimiento
    @cedula_juridica VARCHAR(20),
    @nombre_hotel NVARCHAR(100),
    @provincia NVARCHAR(50),
    @canton NVARCHAR(50),
    @distrito NVARCHAR(50),
    @url_web NVARCHAR(200)
AS
BEGIN
    INSERT INTO Establecimiento
    (cedula_juridica, nombre_hotel, provincia, canton, distrito, url_web)
    VALUES
    (@cedula_juridica, @nombre_hotel, @provincia, @canton, @distrito, @url_web);
END;
GO


--sp_ActualizarEstablecimiento
CREATE OR ALTER PROCEDURE sp_ActualizarEstablecimiento
    @cedula_juridica VARCHAR(20),
    @nombre_hotel NVARCHAR(100),
    @provincia NVARCHAR(50),
    @canton NVARCHAR(50),
    @distrito NVARCHAR(50),
    @url_web NVARCHAR(200)
AS
BEGIN
    UPDATE Establecimiento
    SET
        nombre_hotel = @nombre_hotel,
        provincia = @provincia,
        canton = @canton,
        distrito = @distrito,
        url_web = @url_web
    WHERE cedula_juridica = @cedula_juridica;
END;
GO

--TELÉFONOS DE ESTABLECIMIENTO

--sp_InsertarTelefonoEstablecimiento
CREATE OR ALTER PROCEDURE sp_InsertarTelefonoEstablecimiento
    @cedula_juridica VARCHAR(20),
    @numero VARCHAR(20)
AS
BEGIN
    INSERT INTO Telefono_Establecimiento
    (cedula_juridica, numero)
    VALUES
    (@cedula_juridica, @numero);
END;
GO

--sp_EliminarTelefonoEstablecimiento
CREATE OR ALTER PROCEDURE sp_EliminarTelefonoEstablecimiento
    @cedula_juridica VARCHAR(20),
    @numero VARCHAR(20)
AS
BEGIN
    DELETE FROM Telefono_Establecimiento
    WHERE cedula_juridica = @cedula_juridica
      AND numero = @numero;
END;
GO

--TIPO DE HABITACIÓN

--sp_InsertarTipoHabitacion
CREATE OR ALTER PROCEDURE sp_InsertarTipoHabitacion
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(200),
    @precio DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Tipo_Habitacion
    (nombre, descripcion, precio)
    VALUES
    (@nombre, @descripcion, @precio);
END;
GO

--sp_ActualizarTipoHabitacion
CREATE OR ALTER PROCEDURE sp_ActualizarTipoHabitacion
    @id_tipo INT,
    @nombre NVARCHAR(100),
    @descripcion NVARCHAR(200),
    @precio DECIMAL(10,2)
AS
BEGIN
    UPDATE Tipo_Habitacion
    SET
        nombre = @nombre,
        descripcion = @descripcion,
        precio = @precio
    WHERE id_tipo = @id_tipo;
END;
GO

--HABITACIONES

--sp_InsertarHabitacion
CREATE OR ALTER PROCEDURE sp_InsertarHabitacion
    @cedula_juridica VARCHAR(20),
    @id_tipo INT,
    @numero INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Habitacion
        WHERE cedula_juridica = @cedula_juridica
          AND numero = @numero
    )
    BEGIN
        RAISERROR('Ya existe esta habitacion', 16, 1);
        RETURN;
    END

    INSERT INTO Habitacion
    (cedula_juridica, id_tipo, numero, estado)
    VALUES
    (@cedula_juridica, @id_tipo, @numero, 'LIBRE');
END;
GO

--sp_ActualizarHabitacion
CREATE OR ALTER PROCEDURE sp_ActualizarHabitacion
    @id_habitacion INT,
    @id_tipo INT,
    @numero INT
AS
BEGIN
    UPDATE Habitacion
    SET
        id_tipo = @id_tipo,
        numero = @numero
    WHERE id_habitacion = @id_habitacion;
END;
GO

--sp_CambiarEstadoHabitacion (Libre / Ocupada / Mantenimiento)
CREATE OR ALTER PROCEDURE sp_CambiarEstadoHabitacion
    @id_habitacion INT,
    @estado NVARCHAR(20)
AS
BEGIN
    UPDATE Habitacion
    SET estado = @estado
    WHERE id_habitacion = @id_habitacion;
END;
GO

--CLIENTES

--sp_InsertarCliente
CREATE OR ALTER PROCEDURE sp_InsertarCliente
    @identificacion VARCHAR(20),
    @nombre NVARCHAR(100),
    @apellidos NVARCHAR(100),
    @fecha_nacimiento DATE,
    @correo NVARCHAR(100)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Cliente
        WHERE identificacion = @identificacion
    )
    BEGIN
        RAISERROR('El cliente ya existe', 16, 1);
        RETURN;
    END

    INSERT INTO Cliente
    (identificacion, nombre, apellidos, fecha_nacimiento, correo)
    VALUES
    (@identificacion, @nombre, @apellidos, @fecha_nacimiento, @correo);
END;
GO
--sp_ActualizarCliente
CREATE OR ALTER PROCEDURE sp_ActualizarCliente
    @identificacion VARCHAR(20),
    @nombre NVARCHAR(100),
    @apellidos NVARCHAR(100),
    @fecha_nacimiento DATE,
    @correo NVARCHAR(100)
AS
BEGIN
    UPDATE Cliente
    SET
        nombre = @nombre,
        apellidos = @apellidos,
        fecha_nacimiento = @fecha_nacimiento,
        correo = @correo
    WHERE identificacion = @identificacion;
END;
GO

--sp_AgregarTelefonoCliente
CREATE OR ALTER PROCEDURE sp_AgregarTelefonoCliente
    @identificacion VARCHAR(20),
    @numero VARCHAR(20)
AS
BEGIN
    INSERT INTO Telefono_Cliente
    (identificacion, numero)
    VALUES
    (@identificacion, @numero);
END;
GO
--sp_EliminarTelefonoCliente
CREATE OR ALTER PROCEDURE sp_EliminarTelefonoCliente
    @identificacion VARCHAR(20),
    @numero VARCHAR(20)
AS
BEGIN
    DELETE FROM Telefono_Cliente
    WHERE identificacion = @identificacion
      AND numero = @numero;
END;
GO
--RESERVAS 

--sp_CrearReserva
CREATE OR ALTER PROCEDURE sp_CrearReserva
    @identificacion VARCHAR(20),
    @id_habitacion INT,
    @fecha_ingreso DATETIME,
    @fecha_salida DATETIME,
    @cantidad_personas INT
AS
BEGIN
    IF (@fecha_salida <= @fecha_ingreso)
    BEGIN
        RAISERROR('Fecha Inválida', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM Reservacion
        WHERE id_habitacion = @id_habitacion
          AND @fecha_ingreso < fecha_salida
          AND @fecha_salida > fecha_hora_ingreso
    )
    BEGIN
        RAISERROR('Habitación no disponible', 16, 1);
        RETURN;
    END

    INSERT INTO Reservacion
    (identificacion, id_habitacion, fecha_hora_ingreso, fecha_salida, cantidad_personas)
    VALUES
    (@identificacion, @id_habitacion, @fecha_ingreso, @fecha_salida, @cantidad_personas);
END;
GO
--sp_ActualizarReserva
CREATE OR ALTER PROCEDURE sp_ActualizarReserva
    @id_reserva INT,
    @fecha_ingreso DATETIME,
    @fecha_salida DATETIME,
    @cantidad_personas INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Reservacion
        WHERE id_reserva = @id_reserva
          AND fecha_salida < GETDATE()
    )
    BEGIN
        RAISERROR('Cambio Inválido', 16, 1);
        RETURN;
    END

    UPDATE Reservacion
    SET
        fecha_hora_ingreso = @fecha_ingreso,
        fecha_salida = @fecha_salida,
        cantidad_personas = @cantidad_personas
    WHERE id_reserva = @id_reserva;
END;
GO
--sp_CerrarReserva 
CREATE OR ALTER PROCEDURE sp_CerrarReserva
    @id_reserva INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Reservacion
        WHERE id_reserva = @id_reserva
          AND fecha_salida <= GETDATE()
    )
    BEGIN
        RAISERROR('Ya terminó', 16, 1);
        RETURN;
    END

    UPDATE Reservacion
    SET fecha_salida = GETDATE()
    WHERE id_reserva = @id_reserva;
END;
GO

--FACTURAS

--sp_PagarFactura
CREATE OR ALTER PROCEDURE sp_PagarFactura
    @id_factura INT,
    @metodo_pago NVARCHAR(50)
AS
BEGIN
    UPDATE Factura
    SET
        metodo_pago = @metodo_pago
    WHERE id_factura = @id_factura;
END;
GO

--ACTIVIDADES DE RECREACIÓN

--sp_InsertarEmpresaRecreacion
CREATE OR ALTER PROCEDURE sp_InsertarEmpresaRecreacion
    @nombre VARCHAR(120),
    @cedula_juridica VARCHAR(25),
    @correo VARCHAR(120),
    @nombre_contacto VARCHAR(120),
    @provincia VARCHAR(60),
    @canton VARCHAR(60),
    @distrito VARCHAR(60),
    @senas_exactas VARCHAR(250),
    @precio DECIMAL(10,2)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Empresa_Recreacion
        WHERE cedula_juridica = @cedula_juridica
    )
    BEGIN
        RAISERROR('Ya existe', 16, 1);
        RETURN;
    END

    INSERT INTO Empresa_Recreacion
    (nombre, cedula_juridica, correo, nombre_contacto, provincia, canton, distrito, señas_exactas, precio)
    VALUES
    (@nombre, @cedula_juridica, @correo, @nombre_contacto, @provincia, @canton, @distrito, @senas_exactas, @precio);
END;
GO

--sp_ActualizarEmpresaRecreacion
CREATE OR ALTER PROCEDURE sp_ActualizarEmpresaRecreacion
    @id_empresa_recreacion INT,
    @nombre VARCHAR(120),
    @correo VARCHAR(120),
    @nombre_contacto VARCHAR(120),
    @provincia VARCHAR(60),
    @canton VARCHAR(60),
    @distrito VARCHAR(60),
    @senas_exactas VARCHAR(250),
    @precio DECIMAL(10,2)
AS
BEGIN
    UPDATE Empresa_Recreacion
    SET
        nombre = @nombre,
        correo = @correo,
        nombre_contacto = @nombre_contacto,
        provincia = @provincia,
        canton = @canton,
        distrito = @distrito,
        señas_exactas = @senas_exactas,
        precio = @precio
    WHERE id_empresa_recreacion = @id_empresa_recreacion;
END;
GO

--sp_EliminarEmpresaRecreacion
CREATE OR ALTER PROCEDURE sp_EliminarEmpresaRecreacion
    @id_empresa_recreacion INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Empresa_Recreacion
    WHERE id_empresa_recreacion = @id_empresa_recreacion;
END;
GO

--sp_InsertarActividad
CREATE OR ALTER PROCEDURE sp_InsertarTipoActividad
    @nombre VARCHAR(80)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Tipo_Actividad
        WHERE nombre = @nombre
    )
    BEGIN
        RAISERROR('Ya existe', 16, 1);
        RETURN;
    END

    INSERT INTO Tipo_Actividad (nombre)
    VALUES (@nombre);
END;
GO
--sp_EliminarTipoActividad
CREATE OR ALTER PROCEDURE sp_EliminarTipoActividad
    @id_tipo_actividad INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Tipo_Actividad
    WHERE id_tipo_actividad = @id_tipo_actividad;
END;
GO

--sp_EliminarActividadEmpresa
CREATE OR ALTER PROCEDURE sp_EliminarActividadEmpresa
    @id_empresa_recreacion INT,
    @id_tipo_actividad INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Empresa_Actividad
    WHERE id_empresa_recreacion = @id_empresa_recreacion
      AND id_tipo_actividad = @id_tipo_actividad;
END;
GO
--sp_AgregarServicioEmpresa
CREATE OR ALTER PROCEDURE sp_AgregarServicioEmpresa
    @id_empresa_recreacion INT,
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Empresa_Servicio_Recreacion
    (id_empresa_recreacion, id_servicio)
    VALUES
    (@id_empresa_recreacion, @id_servicio);
END;
GO
--sp_EliminarServicioEmpresa
CREATE OR ALTER PROCEDURE sp_EliminarServicioEmpresa
    @id_empresa_recreacion INT,
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Empresa_Servicio_Recreacion
    WHERE id_empresa_recreacion = @id_empresa_recreacion
      AND id_servicio = @id_servicio;
END;
GO
