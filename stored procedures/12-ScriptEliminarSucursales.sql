use g05com2900

go

-- Procedimiento almacenado para eliminación lógica de una sucursal
create or alter procedure sucursales.EliminarSucursal
    @id int
as
begin
    -- Verificamos si la sucursal existe
    if not exists(select 1 from sucursales.Sucursal where id = @id and eliminado = 0)
    begin
        print 'No se encontró la sucursal con el ID especificado o ya está eliminada.';
        return;
    end

    -- Realizamos la eliminación lógica de la sucursal
    update sucursales.Sucursal
    set eliminado = 1
    where id = @id;

    print 'Sucursal eliminada lógicamente con éxito.';
end;

go

-- Procedimiento almacenado para eliminación lógica de un empleado
create or alter procedure sucursales.EliminarEmpleado
    @legajo int
as
begin
    -- Verificamos si el empleado existe
    if not exists(select 1 from sucursales.Empleado where legajo = @legajo and eliminado = 0)
    begin
        print 'No se encontró el empleado con el ID especificado o ya está eliminado.';
        return;
    end

    -- Realizamos la eliminación lógica del empleado
    update sucursales.Empleado
    set eliminado = 1
    where legajo = @legajo;

    print 'Empleado eliminado lógicamente con éxito.';
end;

go
