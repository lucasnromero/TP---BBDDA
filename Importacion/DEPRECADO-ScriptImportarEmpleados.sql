--DEPRECADO

use g05com2900;
go

create or alter procedure sucursales.ImportarEmpleado
    @rutaxlsx nvarchar(max)
as
begin
    -- crear tabla temporal para almacenar los datos del excel
    create table sucursales.#empleado_temp (
        legajo int primary key,
        nombre varchar(50),
        apellido varchar(50),
        dni int,
        direccion varchar(100),
        email_personal varchar(75),
        email_empresa varchar(75),
        cuil int,
        cargo varchar(30),
        sucursal varchar(60),
        turno varchar(30)
    );

    declare @sql nvarchar(max);

    -- consulta para insertar los datos desde el excel a la tabla temporal
    set @sql = '
        insert into sucursales.#empleado_temp (legajo, nombre, apellido, dni, direccion, email_personal, email_empresa, cuil, cargo, sucursal, turno)
        select [legajo/id] as legajo,
               [nombre],
               [apellido],
               [dni],
               [direccion],
               [email personal] as email_personal,
               [email empresa] as email_empresa,
               [cuil],
               [cargo],
               [sucursal],
               [turno]
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' +  @rutaxlsx + ''',
            ''select * from [empleados$A1:K17]'' -- Especifica el rango exacto
        )';

    exec sp_executesql @sql;

    -- insertar los registros desde la tabla temporal a sucursales.empleado sin duplicados
    insert into sucursales.empleado (legajo, nombre, apellido, email_personal, email_empresa, cargo, turno, cuil, direccion, id_sucursal)
    select
		temp.legajo,
        temp.nombre,
        temp.apellido,
        temp.email_personal,
        temp.email_empresa,
        temp.cargo,
        temp.turno,
        isnull(temp.cuil, temp.dni) as cuil, -- usar dni como cuil si cuil está vacío
        temp.direccion,
        s.id as id_sucursal
    from sucursales.#empleado_temp as temp
    inner join sucursales.sucursal as s on s.localidad = temp.sucursal
    left join sucursales.empleado as e on e.legajo = temp.legajo
    where e.legajo is null; -- solo insertar si no existe en sucursales.empleado

    -- eliminar la tabla temporal
    drop table if exists sucursales.#empleado_temp;
    
end;
go


select * from sucursales.#empleado_temp

-- Ejecución del procedimiento con el archivo especificado
exec sucursales.ImportarEmpleado @rutaxlsx = 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Informacion_complementaria.xlsx';

-- Verificación de los datos importados
select * from sucursales.Empleado;

-- Configuración de permisos para usar OPENROWSET
sp_configure 'show advanced options', 1;
RECONFIGURE;

sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1;
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1;
