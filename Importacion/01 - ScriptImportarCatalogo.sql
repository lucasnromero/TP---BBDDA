use g05com2900;
go

create or alter procedure productos.ImportarCatalogoDesdeCSV
    @rutacsv nvarchar(max)
as
begin
    create table productos.#producto_temp(
        id_producto int primary key,
        categoria varchar(40),
        nombre varchar(100),
        precio_unitario decimal(10,2),
        precio_de_referencia decimal(10,2),
        unidad_de_referencia varchar(10),
        fecha datetime
    );

    declare @sql nvarchar(max);
    set @sql = '
        bulk insert productos.#producto_temp
        from ''' + @rutacsv + '''
        with (
            format = ''csv'',
            fieldterminator = '','',
            rowterminator = ''0x0a'',
            firstrow = 2,
            codepage = ''65001''
        )';

    exec sp_executesql @sql;

	begin try

 -- Insertar registros en productos.Catalogo solo si no existen en la tabla
    insert into productos.Catalogo (id, categoria, nombre, precio, precio_referencia, unidad_referencia, fecha)
        select id_producto, categoria, nombre, precio_unitario, precio_de_referencia, unidad_de_referencia, fecha
        from productos.#producto_temp as tmp
        where not exists (
            select 1
            from productos.Catalogo as p
            where p.id = tmp.id_producto
        );

    end try

    begin catch

        -- Manejo de errores
        print 'Ocurrió un error durante la importación';
        print error_message();

    end catch;

    drop table if exists productos.#producto_temp;
    
end;
go

go

-- Ejecutar el procedimiento almacenado con la ruta del archivo CSV
exec productos.ImportarCatalogoDesdeCSV @rutacsv = 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Productos\catalogo.csv'; 

select * from productos.Catalogo

go
