USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'adminHotel')
    CREATE LOGIN adminHotel
    WITH PASSWORD = 'AdminHotel123!';
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'visitante')
    CREATE LOGIN visitante
    WITH PASSWORD = 'Visitante123!';
GO

USE ProyectoVerano;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AdminRole')
    CREATE ROLE AdminRole;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'UsuarioRole')
    CREATE ROLE UsuarioRole;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'adminHotel')
    CREATE USER adminHotel FOR LOGIN adminHotel;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'visitante')
    CREATE USER visitante FOR LOGIN visitante;
GO

ALTER ROLE AdminRole ADD MEMBER adminHotel;
ALTER ROLE UsuarioRole ADD MEMBER visitante;
GO

GRANT EXEC TO AdminRole;
GRANT SELECT ON SCHEMA::dbo TO AdminRole;
GO

GRANT SELECT ON dbo.vw_Hoteles TO UsuarioRole;
GRANT SELECT ON dbo.vw_TiposHabitaciones TO UsuarioRole;
GRANT SELECT ON dbo.vw_HabitacionesInfo TO UsuarioRole;
GRANT SELECT ON dbo.vw_HabitacionDisponible TO UsuarioRole;
GRANT SELECT ON dbo.vw_Clientes TO UsuarioRole;
GRANT EXEC ON dbo.sp_CrearReserva TO UsuarioRole;
GO
