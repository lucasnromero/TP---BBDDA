--DEPRECADO

use g05com2900;
go

create or alter procedure productos.ImportarProductosImportados
    @rutaxlsx nvarchar(max),
    @tipodecambio decimal(10,2)
as
begin

    -- Crear tabla temporal para almacenar los datos del Excel
    create table productos.#ProductosImportadosTemp(
        idProducto int,
        NombreProducto varchar(100),
        Proveedor varchar(100),
        Categoria varchar(100),
        CantidadPorUnidad varchar(100),
        PrecioUnidad decimal(10,2)
    );

    declare @sql nvarchar(max);

    -- Preparar la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into productos.#ProductosImportadosTemp(idProducto, NombreProducto, Proveedor, Categoria, CantidadPorUnidad, PrecioUnidad)
        select [idProducto], [NombreProducto], [Proveedor], [Categoría], [CantidadPorUnidad], [PrecioUnidad]
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [Listado de Productos$]''
        )';

    -- Ejecutar la consulta dinámica
    exec sp_executesql @sql;

    -- Insertar los registros desde la tabla temporal a productos.ProductoImportado sin duplicados
    insert into productos.ProductoImportado (id_producto, cantidad_por_unidad, nombre, categoria, proveedor, precio_por_unidad)
    select 
        idProducto, 
        CantidadPorUnidad, 
        NombreProducto, 
        Categoria, 
        Proveedor, 
        PrecioUnidad * @tipodecambio  -- Convertir el precio de dólares a pesos
    from productos.#ProductosImportadosTemp as temp
    where not exists (
        select 1
        from productos.ProductoImportado as p
        where p.id_producto = temp.idProducto
    );

    -- Eliminar la tabla temporal
    drop table if exists productos.#ProductosImportadosTemp;
    
end;
go

-- Ejecución del procedimiento con el archivo y tipo de cambio especificados
exec productos.ImportarProductosImportados @rutaxlsx = 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Productos\Productos_importados.xlsx', @tipodecambio = 1200;

-- Verificación de los datos importados
select * from productos.ProductoImportado;

-- Configuración de permisos para usar OPENROWSET
sp_configure 'show advanced options', 1;
RECONFIGURE;

sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1;
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1;
