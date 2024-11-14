use g05com2900;
go

create or alter procedure sucursales.ImportarSucursal
    @rutaxlsx nvarchar(max)
as
begin

    -- Crear tabla temporal para almacenar los datos del Excel
    create table sucursales.#SucursalTemp(
        Ciudad varchar(60),
        Localidad varchar(100),
        Direccion varchar(100),
        Horario varchar(100),
        Telefono varchar(20)
    );

    declare @sql nvarchar(max);

    -- Preparar la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into sucursales.#SucursalTemp(Ciudad, Localidad, Direccion, Horario, Telefono)
        select [Ciudad], [Reemplazar por], [direccion], [horario], [telefono]
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [sucursal$]''
        )';

    -- Ejecutar la consulta dinámica
    exec sp_executesql @sql;

    -- Insertar los registros desde la tabla temporal a sucursales.Sucursal sin duplicados
    insert into sucursales.Sucursal (ciudad, localidad, direccion, horario, telefono)
    select 
        Ciudad, 
        Localidad, 
        Direccion, 
        Horario, 
        Telefono
    from sucursales.#SucursalTemp as temp
    where not exists (
        select 1
        from sucursales.Sucursal as s
        where s.ciudad = temp.Ciudad and s.localidad = temp.Localidad
    );

    -- Eliminar la tabla temporal
    drop table if exists sucursales.#SucursalTemp;
    
end;
go

select * from sucursales.Sucursal

-- Ejecución del procedimiento con el archivo especificado
exec sucursales.ImportarSucursal @rutaxlsx = 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Informacion_complementaria.xlsx';

-- Verificación de los datos importados
select * from sucursales.Sucursal;

-- Configuración de permisos para usar OPENROWSET
sp_configure 'show advanced options', 1;
RECONFIGURE;

sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1;
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1;
