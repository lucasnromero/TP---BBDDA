--Nos posicionamos en la base datos
use g05com2900
go

--Configuramos los permisos para usar OPENROWSET
sp_configure 'show advanced options', 1;
RECONFIGURE;
go
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
go
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1;
go
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1;
go

--Creamos el store procedure para importar las lineas de producto
create or alter procedure productos.ImportarLineaDeProducto
    @rutaxlsx nvarchar(255)
as
begin
    --Creamos una tabla temporal para cargar los datos desde el archivo de Excel
    create table #LineaDeProductoTemp (
        linea varchar(100),
        categoria varchar(100)
    );
	declare @sql nvarchar(max);
	--Preparamos la consulta dinámica para leer el Excel usando OPENROWSET
	set @sql = '
		insert into #LineaDeProductoTemp (linea, categoria)
		select [Línea de producto] as linea, [Producto] as categoria
		from openrowset(
			''microsoft.ace.oledb.12.0'',
			''excel 12.0;database=' + @rutaxlsx + ';hdr=yes;'',
			''select [Línea de producto], [Producto] from [Clasificacion productos$]''
		);
	';
	--Ejecutamos la consulta dinámica
	exec sp_executesql @sql;
    --Insertamos las líneas de producto en la tabla de LineaDeProducto
    insert into productos.LineaDeProducto(linea,categoria)
    select linea,categoria
    from #LineaDeProductoTemp
    where linea is not null and linea <> '';
    --Limpiamos la tabla temporal
    drop table #LineaDeProductoTemp;
end;
go
--Ejecutamos el procedimiento con el archivo especificado
exec productos.ImportarLineaDeProducto @rutaxlsx = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Informacion_complementaria.xlsx';
go

--Creamos el store procedure para importar las sucursales
create or alter procedure sucursales.ImportarSucursal
    @rutaxlsx nvarchar(max)
as
begin
    --Creamos la tabla temporal para almacenar los datos del Excel
    create table #SucursalTemp(
        ciudad varchar(60),
        direccion varchar(100),
        horario varchar(100),
        telefono varchar(20)
    );
    declare @sql nvarchar(max);
    --Preparamos la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into #SucursalTemp(ciudad, direccion, horario, telefono)
        select [Reemplazar por], [direccion], [Horario], [Telefono]
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [sucursal$]'');
		';
    --Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
	--Creamos una tabla temporal para actualizar luego los cuits
	 create table #NuevasSucursales (
        id int
    );
    --Insertamos los registros desde la tabla temporal a sucursales.Sucursal sin duplicados
    insert into sucursales.Sucursal (ciudad, direccion, horario, telefono)
    output inserted.id into #NuevasSucursales(id)
    select ciudad, direccion, horario, telefono
    from #SucursalTemp as t
    where not exists (
        select 1
        from sucursales.Sucursal as s
        where s.ciudad = t.ciudad
    );
	--Calculamos el CUIT para todas las nuevas sucursales
    update sucursales.Sucursal
    set cuit = sucursales.CalcularCUIT(id)
    where id in (select id from #NuevasSucursales);
    --Eliminamos las tablas temporales
    drop table if exists #SucursalTemp;
	drop table if exists #NuevasSucursales;
end;
go
--Ejecutamos el procedimiento con el archivo especificado
exec sucursales.ImportarSucursal @rutaxlsx = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Informacion_complementaria.xlsx';
go

--Creamos el store procedure para importar los empleados
create or alter procedure sucursales.ImportarEmpleado
    @rutaxlsx nvarchar(max)
as
begin
    --Creamos la tabla temporal para almacenar los datos del excel
    create table sucursales.#EmpleadoTemp (
        legajo int primary key,
        nombre varchar(50),
        apellido varchar(50),
        dni int,
        direccion varchar(100),
        email_personal varchar(75),
        email_empresa varchar(75),
        cargo varchar(30),
        sucursal varchar(60),
        turno varchar(30)
    );
    declare @sql nvarchar(max);
    --Preparamos la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into sucursales.#EmpleadoTemp (legajo, nombre, apellido, dni, direccion, email_personal, email_empresa, cargo, sucursal, turno)
        select [legajo/id] as legajo,
               [nombre],
               [apellido],
               [dni],
               [direccion],
               [email personal] as email_personal,
               [email empresa] as email_empresa,
               [cargo],
               [sucursal],
               [turno]
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' +  @rutaxlsx + ''',
            ''select * from [Empleados$A1:K17]'')
		';
	--Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
	--Insertamos los dinstintos tipos de cargo sin repetir
	insert into sucursales.TipoDeCargo(tipo)
	select distinct cargo
	from #EmpleadoTemp as t
	where not exists (select 1 from sucursales.TipoDeCargo as s
    where s.tipo = t.cargo);
	--Insertamos los distintos tipos de turno sin repetir
	insert into sucursales.Turno(turno)
	select distinct turno
	from #EmpleadoTemp as t
	where not exists (select 1 from sucursales.Turno as s
    where s.turno = t.turno);
    --Insertamos los registros desde la tabla temporal a la tabla de empleados sin duplicados
    insert into sucursales.Empleado (
        legajo, nombre, apellido, dni, direccion, email_personal, email_empresa, cuil, id_cargo, id_turno, id_sucursal
    )
    select
        t.legajo,
        t.nombre,
        t.apellido,
        t.dni,
        t.direccion,
        t.email_personal,
        t.email_empresa,
		sucursales.CalcularCUIL(t.dni,null),
        cargo.id as id_cargo,
        turno.id as id_turno,
        sucursal.id as id_sucursal
    from #EmpleadoTemp as t
    --Juntamos con la tabla de TipoDeCargo
    inner join sucursales.TipoDeCargo as cargo on cargo.tipo = t.cargo
    --Juntamos con la tabla de Turno
    inner join sucursales.Turno as turno on turno.turno = t.turno
    --Juntamos con la tabla de Sucursal
    inner join sucursales.Sucursal as sucursal on sucursal.ciudad = t.sucursal
    --Evitamos los duplicados en la tabla Empleado
    where not exists (select 1 from sucursales.Empleado as e
    where e.legajo = t.legajo);
    --Eliminamos la tabla temporal
    drop table if exists sucursales.#empleado_temp;   
end;
go
--Ejecutamos el procedimiento con el archivo especificado
exec sucursales.ImportarEmpleado @rutaxlsx = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Informacion_complementaria.xlsx';
go

--Creamos el store procedure para importar los medios de pago
create or alter procedure ventas.ImportarMedioDePago
    @rutaxlsx nvarchar(max)
as
begin
    --Creamos tabla temporal para almacenar los datos del Excel
    create table #MedioDePagoTemp (
        tipo varchar(40)
    );
    declare @sql nvarchar(max);
    --Preparamos la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into #MedioDePagoTemp (tipo)
        select 
            [F1] tipo
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; hdr=yes; database=' + @rutaxlsx + ''',
            ''select * from [medios de pago$B2:B100]''
        )';
	--Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
    --Insertamos los registros válidos en la tabla de MedioDePago
    insert into ventas.MedioDePago (tipo)
    select tipo
    from #MedioDePagoTemp
    --Eliminamos la tabla temporal
    drop table if exists ventas.#medio_pago_temp;
end;
go
--Ejecutamos el procedimiento con el archivo especificado
exec ventas.ImportarMedioDePago @rutaxlsx = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Informacion_complementaria.xlsx';
go


