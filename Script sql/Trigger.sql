--Trigger
CREATE OR ALTER TRIGGER tr_GenerarFacturaCheckout
ON Reservacion
AFTER UPDATE
AS
BEGIN
    INSERT INTO Factura
    (
        id_reserva,
        cargos_habitacion,
        numero_noches,
        total,
        metodo_pago,
        fecha_hora_registro
    )
    SELECT
        inser.id_reserva,
        th.precio AS cargos_habitacion,
        CASE
            WHEN DATEDIFF(DAY, inser.fecha_hora_ingreso, inser.fecha_salida) = 0 THEN 1
            ELSE DATEDIFF(DAY, inser.fecha_hora_ingreso, inser.fecha_salida)
        END AS numero_noches,
        th.precio *
        CASE
            WHEN DATEDIFF(DAY, inser.fecha_hora_ingreso, inser.fecha_salida) = 0 THEN 1
            ELSE DATEDIFF(DAY, inser.fecha_hora_ingreso, inser.fecha_salida)
        END AS total, 'Efectivo' AS metodo_pago,

        GETDATE() AS fecha_hora_registro

    FROM inserted inser
    JOIN deleted del ON inser.id_reserva = del.id_reserva
    JOIN Habitacion hab ON inser.id_habitacion = hab.id_habitacion
    JOIN Tipo_Habitacion th ON hab.id_tipo = th.id_tipo

    WHERE
        del.fecha_salida > GETDATE()
        AND inser.fecha_salida <= GETDATE() AND NOT EXISTS (
            SELECT 1
            FROM Factura
            WHERE Factura.id_reserva = inser.id_reserva
        );
END;
GO