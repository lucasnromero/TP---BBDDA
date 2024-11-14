--Para ejecutar este script primero debio haber ejecutado el script de CreacionGeneral 

--Nos posicionamos en la base datos
use g05com2900
go


--Creamos el store procedure para actualizar el genero de la tabla empleados del esquema Sucursales
create procedure sucursales.ActualizarGeneroEmpleado
    @legajo int,
    @id_genero int
as
begin
    -- Corroboramos si existe el cliente 
    if exists (select 1 from sucursales.empleado where legajo = @legajo)
    begin
        update sucursales.empleado
        set
            id_genero = @id_genero
        where legajo = @legajo;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go


--Creamos el store procedure para actualizar la sucursal de la tabla empleados del esquema Sucursales
create procedure sucursales.ActualizarSucursalEmpleado
    @legajo int,
    @id_sucursal int
as
begin
    -- Corroboramos si existe el cliente 
    if exists (select 1 from sucursales.empleado where legajo = @legajo)
    begin
        update sucursales.empleado
        set
            id_sucursal = @id_sucursal
        where legajo = @legajo;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go



--Creamos el store procedure para actualizar el nombre de la tabla empleados del esquema Sucursales
create procedure sucursales.ActualizarNombreEmpleado
    @legajo int,
    @nombre varchar(20)
as
begin
    -- Corroboramos si existe el empleado
    if exists (select 1 from sucursales.empleado where legajo = @legajo)
    begin
        update sucursales.empleado
        set
            nombre = @nombre
        where legajo = @legajo;
    end
    else
    begin
        print 'El id de empleado ingresado no existe';
    end
end;
go


--Creamos el store procedure para actualizar el apellido de la tabla empleados del esquema Sucursales
create procedure sucursales.ActualizarApellidoEmpleado
    @legajo int,
    @apellido varchar(20)
as
begin
    -- Corroboramos si existe el empleado
    if exists (select 1 from sucursales.empleado where legajo = @legajo)
    begin
        update sucursales.empleado
        set
            apellido = @apellido
        where legajo = @legajo;
    end
    else
    begin
        print 'El id de empleado ingresado no existe';
    end
end;
go


