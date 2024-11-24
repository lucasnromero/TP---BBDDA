use g05com2900;
go

create or alter procedure ventas.importar_medios_de_pago
    @rutaxlsx nvarchar(max)
as
begin
    -- Crear tabla temporal para almacenar los datos del Excel
    create table ventas.#medio_pago_temp (
        id int identity(1,1) primary key,
        tipo varchar(40)
    );

    declare @sql nvarchar(max);

    -- Consulta para insertar los datos desde el Excel a la tabla temporal
    set @sql = '
        insert into ventas.#medio_pago_temp (tipo)
        select 
            [F1] tipo
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; hdr=yes; database=' + 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Informacion_complementaria.xlsx' + ''',
            ''select * from [medios de pago$B2:B100]''
        )';

    exec sp_executesql @sql;

    -- Insertar registros válidos en ventas.MedioDePago
    insert into ventas.MedioDePago (tipo)
    select tipo
    from ventas.#medio_pago_temp

    -- Eliminar la tabla temporal
    drop table if exists ventas.#medio_pago_temp;
    
end;
go

-- Ejemplo de ejecución
exec ventas.importar_medios_de_pago @rutaxlsx = 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Informacion_complementaria.xlsx';

select * from ventas.MedioDePago
