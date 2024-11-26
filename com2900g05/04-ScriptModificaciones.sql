--Este script se encarga de crear todos los store procedures para las modificaciones en las tablas de la base de datos

--Nos posicionamos en la base datos
use com2900g05
go

--Creamos los store procedures de inserccion para el esquema de clientes, si existen los actualizamos

--Creamos el strore procedure para la modificiacion de la tabla tipo de cliente
create or alter procedure clientes.ActualizarTipoDeCliente 
    @idtipocliente int, 
    @nuevotipocliente varchar(50)
as
begin
    if exists (select 1 from clientes.TipoDeCliente where tipo = @nuevotipocliente)
    begin
        print 'El tipo de cliente ya existe.'
		return;
    end
    update clientes.TipoDeCliente
    set tipo = @nuevotipocliente
    where id = @idtipocliente;
    print 'Tipo de cliente actualizado correctamente con ID: ' + cast(@idtipocliente as varchar(4))
end;
go

--Creamos el strore procedure para la modificiacion de la tabla ciudad
create or alter procedure clientes.ActualizarCiudad 
    @idciudad int, 
    @nuevaciudad varchar(100)
as
begin
    if exists (select 1 from clientes.Ciudad where nombre = @nuevaciudad)
    begin
        print 'La ciudad ya existe.'
		return;
    end
    update clientes.Ciudad
    set nombre = @nuevaciudad
    where id = @idciudad;
    print 'Ciudad actualizada correctamente con ID: ' + cast(@idciudad as varchar(4))
end;
go

--Creamos el strore procedure para la modificiacion de la tabla de genero
create or alter procedure clientes.ActualizarGenero 
    @idgenero int, 
    @nuevogenero varchar(50)
as
begin
    if exists (select 1 from clientes.Genero where tipo = @nuevogenero)
    begin
        print 'El género ya existe.'
		return;
    end
	update clientes.Genero
    set tipo = @nuevogenero
	where ID = @idgenero;
    print 'Género actualizado correctamente con ID: ' + cast(@idgenero as varchar(4))
end;
go

--Creamos el store procedure para la modificacion de la tabla cliente
create or alter procedure clientes.ActualizarCliente 
    @idcliente int, 
    @idtipocliente int, 
    @idciudad int, 
    @idgenero int, 
    @nombre varchar(100), 
    @apellido varchar(100), 
    @dni int, 
    @fechanacimiento date, 
    @direccion varchar(255)
as
begin
    if exists (select 1 from clientes.Cliente where dni = @dni and id <> @idcliente)
    begin
        print 'Ya existe un cliente con este DNI.'
		return;
    end
    update clientes.Cliente
    set id_tipo_de_cliente = @idtipocliente, 
        id_ciudad = @idciudad, 
        id_genero = @idgenero, 
        nombre = @nombre, 
        apellido = @apellido, 
        dni = @dni, 
        fecha_nacimiento = @fechanacimiento, 
        direccion = @direccion
    where id = @idcliente;
    print 'Cliente actualizado correctamente con ID: ' + cast(@idcliente as varchar(4))
end;
go

--Creamos el store procedure para la modificacion de la tabla de sucursal
create or alter procedure sucursales.ActualizarSucursal 
    @idsucursal int, 
    @idciudad int, 
    @nuevadireccion varchar(255), 
    @nuevohorario varchar(100), 
    @nuevotelefono varchar(20)
as
begin
    if exists (select 1 from sucursales.Sucursal where direccion = @nuevadireccion and id_ciudad = @idciudad and id <> @idsucursal)
    begin
        print 'Ya existe una sucursal con esta dirección en esta ciudad.'
		return;
    end

    update sucursales.Sucursal
    set id_ciudad = @idciudad, 
        direccion = @nuevadireccion, 
        horario = @nuevohorario, 
        telefono = @nuevotelefono
    where id = @idsucursal;
    print 'Sucursal actualizada correctamente con ID: ' + cast(@idsucursal as varchar(4))
end;
go

--Creamos el store procedure para la modificacion de la tabla tipo de cargo
create or alter procedure sucursales.ActualizarTipoDeCargo 
    @idtipodecargo int, 
    @nuevotipodecargo varchar(100)
as
begin
    if exists (select 1 from sucursales.TipoDeCargo where tipo = @nuevotipodecargo)
    begin
        print 'El tipo de cargo ya existe.'
		return;
    end
    update sucursales.TipoDeCargo
    set tipo = @nuevotipodecargo
    where id = @idtipodecargo;
    print 'Tipo de cargo actualizado correctamente con el ID: ' + cast(@idtipodecargo as varchar(4))
end;
go

--Creamos el strore procedure para la modificacion de la tabla de turnos
create or alter procedure sucursales.ActualizarTurno 
    @idturno int, 
    @nuevoturno varchar(50)
as
begin
    if exists (select 1 from sucursales.turno where turno = @nuevoturno)
    begin
        print 'El turno ya existe.'
		return;
	end
    update sucursales.Turno
    set turno = @nuevoturno
    where id = @idturno;
    print 'Turno actualizado correctamente con el ID: ' + cast(@idturno as varchar(4))
end;
go

--Cramos el store procedure para la modificacion de la tabla de empleados
create or alter procedure sucursales.ActualizarEmpleado 
    @legajoempleado int, 
    @idtipodecargo int, 
    @idsucursal int, 
    @idturno int, 
    @nuevonombre varchar(100), 
    @nuevoapellido varchar(100), 
    @nuevodni int, 
    @nuevadireccion varchar(255), 
    @nuevoemailpersonal varchar(100), 
    @nuevoemailempresa varchar(100)
as
begin
    if exists (select 1 from sucursales.Empleado where dni = @nuevodni and legajo <> @legajoempleado)
    begin
        print 'Ya existe un empleado con este DNI.'
		return;
    end
    update sucursales.Empleado
    set id_cargo = @idtipodecargo, 
        id_sucursal = @idsucursal, 
        id_turno = @idturno, 
        nombre = @nuevonombre, 
        apellido = @nuevoapellido, 
        dni = @nuevodni, 
        direccion = @nuevadireccion, 
        email_personal = @nuevoemailpersonal, 
        email_empresa = @nuevoemailempresa
    where legajo = @legajoempleado;
    print 'Empleado actualizado correctamente con el Legajo: ' + cast(@legajoempleado as varchar(20))
end;
go

--Creamos el store procedure para la modificacion de la tabla de medio de pago
create or alter procedure ventas.ActualizarMedioDePago 
    @idmediodepago int, 
    @nuevomediodepago varchar(50)
as
begin
    if exists (select 1 from ventas.MedioDePago where tipo = @nuevomediodepago)
    begin
        print 'El medio de pago ya existe.'
		return;
    end
    update ventas.MedioDePago
    set tipo = @nuevomediodepago
    where id = @idmediodepago;
    print 'Medio de pago actualizado correctamente con el ID: ' + cast(@idmediodepago as varchar(4))
end;
go

--Creamos el store procedure para la modificacion de la tabla de tipo de factura
create or alter procedure ventas.ActualizarTipoDeFactura 
    @idtipofactura int, 
    @nuevotipofactura varchar(50)
as
begin
    if exists (select 1 from ventas.TipoDeFactura where tipo = @nuevotipofactura)
    begin
        print 'El tipo de factura ya existe.'
		return;
    end
    update ventas.TipoDeFactura
    set tipo = @nuevotipofactura
    where id = @idtipofactura;
    print 'Tipo de factura actualizado correctamente con el ID: ' + cast(@idtipofactura as varchar(4))
end;
go

--Creamos el store procedure para la modificacion de la tabla de linea de producto
create or alter procedure productos.ActualizarLineaDeProducto 
    @idlineadeproducto int, 
    @nuevalinea varchar(100), 
    @nuevavcategoria varchar(100)
as
begin
    if exists (select 1 from productos.LineaDeProducto where linea = @nuevalinea and categoria = @nuevavcategoria)
    begin
        print 'La línea de producto ya existe.'
		return;
    end
    update productos.lineadeproducto
    set linea = @nuevalinea, 
        categoria = @nuevavcategoria
    where id = @idlineadeproducto;
    print 'Línea de producto actualizada correctamente con el ID: ' + cast(@idlineadeproducto as varchar(4))
end;
go

--Creamos el store procedure para la modificacion de 
create or alter procedure productos.ActualizarProducto 
    @idproducto int, 
    @idlineadeproducto int, 
    @nuevonombreproducto varchar(100), 
    @nuevoprecio decimal(10,2),
	@nuevoprecioreferencia decimal(10,2),
    @nuevaunidadreferencia varchar(50), 
    @nuevafecha smalldatetime
as
begin
    if exists (select 1 from productos.Producto where id_linea_de_producto = @idlineadeproducto and nombre = @nuevonombreproducto)
    begin
        print 'El producto ya existe.'
		return;
    end
    update productos.Producto
    set id_linea_de_producto = @idlineadeproducto, 
        nombre = @nuevonombreproducto, 
        precio = @nuevoprecio, 
        precio_referencia = @nuevoprecioreferencia, 
        unidad_referencia = @nuevaunidadreferencia,
		fecha = @nuevafecha
    where id = @idproducto;
    print 'Producto actualizado correctamente con el ID: ' + cast(@idproducto as varchar(4))
end;

