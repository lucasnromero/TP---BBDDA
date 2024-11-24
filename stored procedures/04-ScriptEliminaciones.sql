--Nos posicionamos en la base de datos
use g05com2900
go

--Creamos los store procedures de eliminacion para el esquema de clientes

--Creamos el store procedura para eliminar un tipo de cliente
create or alter procedure clientes.EliminarTipoDeCliente
    @id int
as
begin
    --Verificamos si el tipo de cliente existe
    if not exists(select 1 from clientes.TipoDeCliente where id = @id)
    begin
        print 'No se encontró el tipo de cliente con el ID especificado.';
        return;
    end
    --Eliminamos el tipo de cliente
    delete from clientes.TipoDeCliente where id = @id;
    print 'Tipo de cliente eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedure para eliminar una ciudad
create or alter procedure clientes.EliminarCiudad
    @id int
as
begin
    --Verificamos si la ciudad existe
    if not exists(select 1 from clientes.Ciudad where id = @id)
    begin
        print 'No se encontró la ciudad con el ID especificado.';
        return;
    end
    --Eliminamos la ciudad
    delete from clientes.Ciudad where id = @id;

    print 'Ciudad eliminada correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedure para eliminar un género
create or alter procedure clientes.EliminarGenero
    @id int
as
begin
    --Verificamos si el género existe
    if not exists(select 1 from clientes.Genero where id = @id)
    begin
        print 'No se encontró el género con el ID especificado.';
        return;
    end
    --Eliminamos el género
    delete from clientes.Genero where id = @id;
    print 'Género eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedure para marcar como eliminado un cliente
create or alter procedure clientes.EliminarCliente
    @id int
as
begin
    --Verificamos si el cliente existe
    if not exists(select 1 from clientes.Cliente where id = @id)
    begin
        print 'No se encontró el cliente con el ID especificado.';
        return;
    end
    --Marcamos como eliminado el cliente
    update clientes.Cliente set eliminado = 1 where id = @id;
    print 'Cliente marcado como eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos los store procedures de eliminacion para el esquema de sucursales

--Creamos el store procedura para marcar como eliminado una sucursal
create or alter procedure sucursales.EliminarSucursal
    @id int
as
begin
    --Verificamos si la sucursal existe
    if not exists(select 1 from sucursales.Sucursal where id = @id and eliminado = 0)
    begin
        print 'No se encontró la sucursal con el ID especificado o ya está eliminada.';
        return;
    end
    --Marcamos como eliminida la sucursal
    update sucursales.Sucursal set eliminado = 1 where id = @id;
    print 'Sucursal marcada como eliminada correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedure para eliminar un tipo de cargo
create or alter procedure sucursales.EliminarTipoDeCargo
	@id int
as
begin
	--Verificamos si el tipo de cargo existe
	if not exists (select 1 from sucursales.TipoDeCargo where id = @id)
	begin
		print 'No se encontró la sucursal con el ID especificado o ya está eliminada.'
		return;
	end
	--Eliminamos el tipo de cargo
	delete from sucursales.TipoDeCargo where id = @id
	print 'Tipo de cargo eliminado correctamene con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedure para eliminar los turnos
create or alter procedure sucursales.Turno
	@id int
as
begin
	--Verificamos si el turno existe
	if not exists (select 1 from sucursales.Turno where id = @id)
	begin
		print 'No se encontró el turno con el ID especificado.'
		return;
	end
	--Elminamos el turno
	delete from sucursales.Turno where id = @id
	print 'Turno eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedure para marcar como eliminado los empleados
create or alter procedure sucursales.EliminarEmpleado
    @legajo int
as
begin
    --Verificamos si el empleado existe
    if not exists(select 1 from sucursales.Empleado where legajo = @legajo and eliminado = 0)
    begin
        print 'No se encontró el empleado con el Legajo especificado o ya está eliminado.';
        return;
    end
    --Marcamos como eliminado el empleado
    update sucursales.Empleado set eliminado = 1 where legajo = @legajo;
    print 'Empleado marcado como eliminado correctamente con el ID: ' + cast(@id as varchar(4));
end;
go

--Creamos los store procedure de eliminacion del esquema de ventas

--Creamos el store procedure para elminar los medios de pago
create or alter procedure ventas.EliminarMedioDePago
	@id int
as
begin
	--Verificamos si el medio de pago existe
	if not exists (select 1 from ventas.MedioDePago where id = @id)
	begin 
		print 'No se encontró el medio de pago con el ID especificado.'
		return;
	end
	--Eliminamos el medio de pago
	delete from ventas.MedioDePago where id = @id
	print 'Medio de pago eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedue para eliminar los tipos de factura
create or alter procedure ventas.EliminarTipoDeFactura
	@id int
as
begin
	--Verificamos si el tipo de factura existe
	if not exists (select 1 from ventas.TipoDeFactura where id = @id)
	begin
		print 'No se encontro el tipo de factura con el ID especificado.'
		return;
	end
	--Eliminamos el tipo de factura
	delete from ventas.TipoDeFactura where id = @id
	print 'Tipo de factura eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;
go

--Creamos el store procedure para eliminar una venta completa

