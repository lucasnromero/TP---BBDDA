--Para ejecutar este script primero debio haber ejecutado el script de CreacionVentas

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los store procedures de inserccion para el esquema de ventas

--Creamos el store procedure para insertar los medios de pago
create or alter procedure ventas.InsertarMedioDePago
    @tipo varchar(40)
as
begin
    --Corroboramos si ya existe el medio de pago 
    if exists(select 1 from ventas.MedioDePago where tipo = @tipo)
    begin  
        print 'Ya existe un medio de pago con esa decripcion.'
        return;
    end
    --Insertamos el nuevo medio de pago
    insert into ventas.MedioDePago (tipo)
    values (@tipo);
    --Mostramos por pantalla el id del nuevo medio de pago
    declare @NuevoID int = scope_identity();
    print 'Medio de pago insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar pagos
create or alter procedure ventas.InsertarPago
	@id_factura int,
	@identificador varchar(100),
	@id_medio int
as
begin
	--Corroboramos si ya existe el pago para la factura, no deberia pagar dos veces la misma factura
	if exists(select 1 from ventas.Pago where id_factura = @id_factura)
	begin
		print 'La factura especificada ya se encuentra pagada.'
		return;
	end
	--Buscamos el monto de la factura
	declare @monto decimal(10,2)
	set @monto = (select total_iva from ventas.Factura where id_factura = @id_factura)
	--Insertamos el pago
	insert into ventas.Pago (id_factura, identificador, monto, id_medio)
	values (@id_factura, @identificador, @monto, @id_medio);
	--Actualizamos el estado de la factura
	update ventas.Factura
	set estado = 'Pagada'
	where id = @id_factura;
	--Mostramos por pantalla el id del pago insertado
	declare @NuevoID int = scope_identity();
	print 'Pago insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar los tipos de factura
create or alter procedure ventas.InsertarTipoDeFactura
    @tipo char(1)
as
begin
    --Corroboramos si ya existe el tipo de factura 
    if exists(select 1 from ventas.TipoDeFactura where tipo = @tipo)
    begin  
        print 'Ya existe ese tipo de factura.'
        return;
    end
    --Insertamos el nuevo tipo de factura
    insert into ventas.TipoDeFactura (tipo)
    values (@tipo);
    --Mostramos por pantalla el id del nuevo tipo de factura
    declare @NuevoID int = scope_identity();
    print 'Tipo de factura insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el tipo de dato para los productos
create or alter type ventas.venta_producto_type as table(
    id_producto int,
    cantidad int
);
go

--Creamos el store procedure para insertar la venta completa
create or alter procedure ventas.InsertarVentaCompleta
    @id_cliente int,
    @id_empleado int,
    @id_sucursal int,
	@id_tipo_factura int,
    @productos venta_producto_type --Tipo de tabla para los productos(con id_producto y cantidad)
as
begin
    --Variables para almacenar datos intermedios
    declare @id_venta int;
    declare @total decimal(10, 2) = 0;
    declare @cantidad_de_productos int = 0;
    declare @precio_unitario decimal(10, 2);
    declare @subtotal decimal(10, 2);
	declare @cuit varchar(20);
    --Insertamos la venta y obtenemos su id respectivo
    insert into ventas.Venta(id_cliente, id_empleado, id_sucursal, total, cantidad_de_productos)
    values (@id_cliente, @id_empleado, @id_sucursal, @total, @cantidad_de_productos);
	set @id_venta = scope_identity();
    --Iteramos sobre los productos de la venta
    declare @id_producto int, @cantidad int;
    declare producto_cursor cursor for
		select id_producto, cantidad from @productos;
    open producto_cursor;
		fetch next from producto_cursor into @id_producto, @cantidad;
    while @@fetch_status = 0
    begin
        --Obtenemos el precio unitario del producto desde la tabla de productos
        select @precio_unitario = precio_unitario from productos.Producto where id = @id_producto;
        --Calculamos el subtotal para este producto
        set @subtotal = @cantidad * @precio_unitario;
        --Insertamos el detalle de la venta
        insert into ventas.DetalleDeVenta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
        values (@id_venta, @id_producto, @cantidad, @precio_unitario, @subtotal);
        --Actualizamos el total y la cantidad de productos
        set @total = @total + @subtotal;
        set @cantidad_de_productos = @cantidad_de_productos + @cantidad;
		--Continuamos con el siguiente producto
        fetch next from producto_cursor into @id_producto, @cantidad;
    end
    close producto_cursor;
    deallocate producto_cursor;
    --Actualizamos la venta con el total calculado y la cantidad de productos
    update ventas.Venta
    set total = @total, cantidad_de_productos = @cantidad_de_productos
    where id = @id_venta;
	--Obtenemos el cuit de la sucursal
	set @cuit = select cuit from sucursales.Sucursal where id = @id_sucursal;
    --Insertamos la factura relacionada con la venta
    insert into ventas.Factura (id_venta, id_tipo_de_factura, total_iva, cuit)
    values (@id_venta, @id_tipo_de_factura, @total * 1.21,@cuit);

    --Mostramos el id de la venta que insertamos
    select @id_venta as id_venta;
end;
go
