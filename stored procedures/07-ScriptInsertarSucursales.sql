--Para ejecutar este script primero debio haber ejecutado el script de CreacionSucursales

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los store procedures de inserccion para el esquema de sucursales

--Creamos el store procedure para insertar sucursales
create or alter procedure sucursales.InsertarSucursal
    @ciudad varchar(20),
    @localidad varchar(20)
as
begin
    --Corroboramos si ya existe una sucursal con la misma ciudad y localidad
    if exists (select 1 from sucursales.Sucursal where ciudad = @ciudad and localidad = @localidad)
    begin
        print 'Ya existe una sucursal con ese nombre y localidad.'
        return;
    end
    --Insertamos la nueva sucursal
    insert into sucursales.Sucursal (ciudad, localidad)
    values (@ciudad, @localidad);
    --Mostramos por pantalla el id de la nueva sucursal
    declare @NuevoID int = scope_identity();
    print 'Sucursal insertada correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar empleados
create or alter procedure  sucursales.InsertarEmpleado
    @id_genero int,
    @id_sucursal int,
    @nombre varchar(20),
    @apellido varchar(20),
    @cuil int,
    @direccion varchar(50)
as
begin
    --Verificamos si existe el empleado que intentamos ingresar, lo validamos atraves del cuil
    if exists (select 1 from sucursales.Empleado where cuil = @cuil)
    begin
        print 'Ya existe un empleado con ese CUIL.'
        return;
    end
    --Insertamos el nuevo empleado
    insert into sucursales.Empleado (id_genero, id_sucursal, nombre, apellido, cuil, direccion)
    values (@id_genero, @id_sucursal, @nombre, @apellido, @cuil, @direccion);
    --Mostramos por pantalla el id del nuevo empleado
    declare @NuevoID int = scope_identity();
    print 'Empleado insertado correctamente con ID:' + cast(@NuevoID as varchar(4));
end;
go
