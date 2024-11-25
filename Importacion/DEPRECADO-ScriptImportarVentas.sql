--DEPRECADO

use g05com2900;
go

create or alter procedure ventas.ImportarVentasDesdeCSV
    @rutacsv nvarchar(max)
as
begin
    -- Crear tabla temporal para almacenar los datos del CSV
    create table ventas.#ventas_temp(
        id_factura varchar(50),
        tipo_factura varchar(50),
        ciudad varchar(100),
        tipo_cliente varchar(50),
        genero varchar(20),
        producto varchar(100),
        precio_unitario varchar(20),
        cantidad varchar(20),
        fecha varchar(20),
        hora varchar(20),
        medio_pago varchar(50),
        empleado varchar(50),
        identificador_pago varchar(50)
    );

    -- Construir el comando BULK INSERT para importar el CSV
    declare @sql nvarchar(max);
    set @sql = '
        bulk insert ventas.#ventas_temp
        from ''' + @rutacsv + '''
        with (
            format = ''csv'',
            fieldterminator = '';'', -- Utilizar tabulación como separador
            rowterminator = ''0x0a'', -- Salto de línea
            firstrow = 2, -- Ignorar encabezado
            codepage = ''65001'' -- Soporte para UTF-8
        )';

    -- Ejecutar el comando BULK INSERT

	exec sp_executesql @sql;
    begin try
        

        -- Insertar registros en la tabla final (si aplica lógica específica)
        -- Aquí solo seleccionamos para verificar que se importaron los datos
        select * from ventas.#ventas_temp;

    end try
    begin catch
        -- Manejo de errores
        print 'Ocurrió un error durante la importación';
        print error_message();
    end catch;

    -- Eliminar la tabla temporal
    drop table if exists ventas.#ventas_temp;
end;
go
