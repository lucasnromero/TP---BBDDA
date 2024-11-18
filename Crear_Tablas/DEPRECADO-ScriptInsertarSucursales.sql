--DEPRECADO

--Para ejecutar este script primero debio haber ejecutado el script de CreacionSucursales

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los store procedures de inserccion para el esquema de sucursales

--Creamos el store procedure para insertar sucursales
create or alter procedure sucursales.InsertarSucursal
    @nombre char(20),
    @localidad char(20)
as
begin
    --Corroboramos si ya existe una sucursal con el mismo nombre y localidad
    if exists (select 1 from sucursales.Sucursal where nombre = @nombre and localidad = @localidad)
    begin
        print 'Ya existe una sucursal con ese nombre y localidad.'
        return;
    end
    --Insertamos la nueva sucursal
    insert into sucursales.Sucursal (nombre, localidad)
    values (@nombre, @localidad);
    --Mostramos por pantalla el id de la nueva sucursal
    declare @NuevoID int = scope_identity();
    print 'Sucursal insertada correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar empleados
create or alter procedure  sucursales.InsertarEmpleado
    @id_genero int,
    @id_sucursal int,
    @nombre char(20),
    @apellido char(20),
    @cuil int,
    @fecha_ingreso date,
    @fecha_egreso date = null,
    @direccion char(50)
as
begin
    --Verificamos si existe el empleado que intentamos ingresar, lo validamos atraves del cuil
    if exists (select 1 from sucursales.Empleado where cuil = @cuil)
    begin
        print 'Ya existe un empleado con ese CUIL.'
        return;
    end
    --Insertamos el nuevo empleado
    insert into sucursales.Empleado (id_genero, id_sucursal, nombre, apellido, cuil, fecha_ingreso, fecha_egreso, direccion)
    values (@id_genero, @id_sucursal, @nombre, @apellido, @cuil, @fecha_ingreso, @fecha_egreso, @direccion);
    --Mostramos por pantalla el id del nuevo empleado
    declare @NuevoID int = scope_identity();
    print 'Empleado insertado correctamente con ID:' + cast(@NuevoID as varchar(4));
end;
go
