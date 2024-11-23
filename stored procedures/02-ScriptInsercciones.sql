--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los store procedures de inserccion para el esquema de clientes, si existen los actualizamos

--Creamos el store procedure par insertar los tipos de clientes
create or alter procedure clientes.InsertarTipoDeCliente
    @tipo varchar(15)
as
begin
    --Corroboramos que el tipo de cliente que queremos insertar no exista
    if exists(select 1 from clientes.TipoDeCliente where tipo = @tipo)
    begin
        print 'Ya existe ese tipo de Cliente.'
        return;
    end
    --Insertamos el tipo de cliente
    insert into clientes.TipoDeCliente(tipo)
    values(@tipo);
    --Mostramos el ID del tipo de cliente insertado
    declare @NuevoID int = scope_identity();
    print 'Tipo de Cliente insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Cremos el store procedure para insertar las cuidades
create or alter procedure clientes.InsertarCiudad
    @nombre varchar(60)
as
begin
    --Corroboramos que la ciudad que queremos insertar no exista
    if exists(select 1 from clientes.Ciudad where nombre = @nombre)
    begin
        print 'Ya existe esa Ciudad.'
        return;
    end
    --Insertamos la ciudad
    insert into clientes.Ciudad(nombre)
    values(@nombre);
    --Mostramos el ID de la ciudad insertada
    declare @NuevoID int = scope_identity();
    print 'Ciudad insertada correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar los generos
create or alter procedure clientes.InsertarGenero
    @tipo varchar(30)
as
begin
    --Corroboramos que el genero que queremos insertar no exista
    if exists(select 1 from clientes.Genero where tipo = @tipo)
    begin
        print 'Ya existe ese Genero.'
        return;
    end
    --Insertamos el genero
    insert into clientes.Genero(tipo)
    values(@tipo);    
    --Mostamos el ID del genero insertado
    declare @NuevoID int = scope_identity();
    print 'Genero insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos los store procedure para insertar los clientes
create or alter procedure clientes.InsertarCliente
    @id_tipo_de_cliente int,
    @id_ciudad int,
    @id_genero int,
    @nombre varchar(50) = null,
    @apellido varchar(50) = null,
    @dni int = null,
    @fecha_nacimiento date = null,
    @direccion varchar(60) = null 
as
begin
    --Corroboramos que el tipo que queremos insertar no exista
    if exists(select 1 from clientes.Cliente where dni = @dni)
    begin
        print 'Ya existe un Cliente con ese DNI.'
        return;
    end

    --Insertamos el cliente
    insert into clientes.Cliente(
        id_tipo_de_cliente, id_ciudad, id_genero, nombre, apellido, dni, fecha_nacimiento, direccion
    )
    values(
        @id_tipo_de_cliente, @id_ciudad, @id_genero, @nombre, @apellido, @dni, @fecha_nacimiento, @direccion
    );
    --Mostamos el ID del clietne insertado
    declare @NuevoID int = scope_identity();
    print 'Cliente insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos los store procedures de inserccion para el esquema de sucursales y algunas funciones

--Creamos la funcion para calcular el cuit de las sucursales
create or alter function sucursales.CalcularCUIT (
    @id_sucursal int
)
returns varchar(15)
as
begin
    declare @prefijo char(2) = '30'  --Prefijo genérico para sucursales
    declare @verificador int = 9      --Verificador genérico
    declare @cuit varchar(15)
    --Completar el id de la sucursal con ceros a la izquierda para tener siempre 8 dígitos
    declare @id_sucursal_completo varchar(8)
	set @id_sucursal_completo = right('00000000' + cast(@id_sucursal as varchar(8)), 8)
    --Formamos el cuit con el formato prefijo-id-verificador
    set @cuit = @prefijo + '-' + @id_sucursal_completo + '-' + cast(@verificador as varchar(1))
    return @cuit
end;
go

--Creamos el store procedure para insertar sucursales
create or alter procedure sucursales.InsertarSucursal
    @ciudad varchar(60),
    @direccion varchar(100),
	@horario varchar(100),
	@telefono varchar(20)
as
begin
    --Corroboramos si ya existe una sucursal con la misma ciudad y localidad
    if exists (select 1 from sucursales.Sucursal where direccion = @direccion and ciudad = @ciudad)
    begin
        print 'Ya existe una sucursal con esa direccion en esa ciudad.'
        return;
    end
    --Insertamos la nueva sucursal
    insert into sucursales.Sucursal (ciudad, direccion, horario, telefono)
    values (@ciudad, @direccion, @horario, @telefono);
    --Declaramos el id de la sucursal que acabamos de insertar
    declare @NuevoID int = scope_identity();
	--Calculamos el cuit de la sucursal
	declare @cuit varchar(15);
	set @cuit = sucursales.CalcularCUIT(@NuevoID);
	--Agregamos en la sucursal el cuit luego de calcularlo
	update sucursales.Sucursal
	set cuit = @cuit
	where id = @NuevoID;
	--Mostramos por pantalla el id de la nueva sucursal
    print 'Sucursal insertada correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar tipos de cargo
create or alter procedure sucursales.InsertarTipoDeCargo
	@tipo varchar(40)
as
begin
	--Corroboramos si ya existe el tipo de cargo
	if exists (select 1 from sucursales.TipoDeCargo where tipo = @tipo)
	begin
		print 'Ya existe un tipo de cargo con esa descripcion'
		return;
	end
	--Insertamos el nuevo tipo de cargo
	insert into sucursales.TipoDeCargo (tipo)
	values (@tipo);
	--Mostramos por pantalla el id del nuevo tipo de cargo
	declare @NuevoID int = scope_identity();
	print 'Tipo de cargo insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar los turnos
create or alter procedure sucursales.InsertarTurno
	@turno varchar(30)
as
begin
	--Corroboramos si ya existe el turno
	if exists (select 1 from sucursales.Turno where turno = @turno)
	begin
		print 'Ya existe un turno con esa descripcion'
		return;
	end
	--Insertamos el nuevo turno
	insert into sucursales.Turno (turno)
	values (@turno);
	--Mostramos por pantalla el id del nuevo turno
	declare @NuevoID int = scope_identity();
	print 'Turno insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos la funcion para calcular los cuils de los empleados
create or alter function sucursales.CalcularCUIL (
    @dni int,
    @id_genero int
)
returns varchar(15)
as
begin
    declare @prefijo char(2)
    declare @suma int
    declare @resto int
    declare @verificador int
    declare @cuil varchar(15)
    --Asignamos el prefijo según el género
    set @prefijo = case @id_genero
        when 1 then '20' --Masculino
        when 2 then '27' --Femenino
        else '23'        --Generico
    end
    --Calculamos el dígito verificador usando módulo 11
    set @suma = 
          (substring(@prefijo, 1, 1) * 5) +
          (substring(@prefijo, 2, 1) * 4) +
          (substring(cast(@dni as varchar(8)), 1, 1) * 3) +
          (substring(cast(@dni as varchar(8)), 2, 1) * 2) +
          (substring(cast(@dni as varchar(8)), 3, 1) * 7) +
          (substring(cast(@dni as varchar(8)), 4, 1) * 6) +
          (substring(cast(@dni as varchar(8)), 5, 1) * 5) +
          (substring(cast(@dni as varchar(8)), 6, 1) * 4) +
          (substring(cast(@dni as varchar(8)), 7, 1) * 3) +
          (substring(cast(@dni as varchar(8)), 8, 1) * 2)
	--Substring toma el primer parametro que es una cadena, por esto es que el dni
	--lo tenemos que convertir a cadena con un cast, luego con el segundo parametro es 
	--el la posicion de inicio de la cadena y el tercer parametro le dice cuantos caracteres
	--va a extraer de la cadena. Por ultimo se multiplica por un numero que corresponde a un
	--algoritmo que se utilza para calcular el cuil

	--Usamos el resto para definir el verificador del cuil
    set @resto = @suma % 11
    if @resto = 0 --Si el resto es 0 el verificador es 0
        set @verificador = 0
    else if @resto = 1 --Si el resto es 1 el prefijo cambia a 23 y los verificadores cambiar a 9 para los masculinos y 4 para femeninos o genericos
        begin
            set @prefijo = '23'
            set @verificador = case @id_genero when 1 then 9 else 4 end
        end
    else --Si el resto es distinto el verificador se calculo con 11 menos el resto
        set @verificador = 11 - @resto
    --Formamos el cuil con el formato prefijo-dni-verificador
    set @cuil = @prefijo + '-' + cast(@dni as varchar(8)) + '-' + cast(@verificador as varchar(1))
    return @cuil
end;
go

--Creamos el store procedure para insertar empleados
create or alter procedure  sucursales.InsertarEmpleado
    @legajo int,
	@id_genero int,
    @nombre varchar(50),
    @apellido varchar(50),
    @dni int,
    @direccion varchar(100),
	@email_personal varchar(75),
	@email_empresa varchar(75),
	@id_cargo int,
	@id_sucursal int,
	@id_turno int
as
begin
    --Verificamos si existe el empleado que intentamos ingresar, lo validamos atraves del legajo
    if exists (select 1 from sucursales.Empleado where legajo = @legajo)
    begin
        print 'Ya existe un empleado con ese legajo.'
        return;
    end
	--Declaramos el cuil
	declare @cuil varchar(15)
    --Calculamos el cuil
    set @cuil = sucursales.CalcularCUIL(@dni, @id_genero)
    --Insertamos el nuevo empleado
    insert into sucursales.Empleado (legajo, id_genero, nombre, apellido, dni, direccion,
		email_personal, email_empresa, cuil, id_cargo, id_sucursal, id_turno)
    values (@legajo, @id_genero, @nombre, @apellido, @dni, @direccion, @email_personal, @email_empresa,
	@cuil, @id_cargo, @id_sucursal, @id_turno);
    --Mostramos por pantalla el id del nuevo empleado
    print 'Empleado insertado correctamente con Legajo: ' + cast(@legajo as varchar(20));
end;
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
	declare @monto decimal(10,2);
	set @monto = (select total_iva from ventas.Factura where id = @id_factura)
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
if not exists (select * from sys.types where name = 'venta_producto_type' and schema_id = schema_id('ventas'))
begin
	create type ventas.venta_producto_type as table(
		id_producto int,
		cantidad int
	);
end;
go

--Creamos el trigger para insertar el codigo por defecto
create or alter trigger ventas.SetearCodigoPorDefecto
on ventas.Factura
after insert
as
begin
    --Actualizamos el codigo con el valor del id si no se especifico en la inserccion
    update ventas.Factura
    set codigo = cast(ventas.Factura.id as varchar(50))
    from ventas.Factura
    inner join inserted on ventas.Factura.id = inserted.id
    where inserted.Codigo is null;
end;
go

--Creamos el store procedure para insertar la venta completa
create or alter procedure ventas.InsertarVentaCompleta
    @id_cliente int,
    @legajo_empleado int,
    @id_sucursal int,
	@id_tipo_de_factura int,
    @productos ventas.venta_producto_type readonly, --Tipo de tabla para los productos(con id_producto y cantidad)
	@codigo varchar(50)= null
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
    insert into ventas.Venta(id_cliente, legajo_empleado, id_sucursal, total, cantidad_de_productos)
    values (@id_cliente, @legajo_empleado, @id_sucursal, @total, @cantidad_de_productos);
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
        set @precio_unitario = (select precio from productos.Producto where id = @id_producto)
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
	set @cuit = (select cuit from sucursales.Sucursal where id = @id_sucursal)
    --Insertamos la factura relacionada con la venta
    insert into ventas.Factura (codigo, id_venta, id_tipo_de_factura, total_iva, cuit)
    values (@codigo, @id_venta, @id_tipo_de_factura, @total * 1.21,@cuit);

    --Mostramos el id de la venta que insertamos
    select @id_venta as id_venta;
end;
go

--Creamos los store procedures de inserccion para el esquema de productos

--Creamos el store procedure para insertar la linea de producto
create or alter procedure productos.InsertarLineaDeProducto
	@nombre varchar(50)
as
begin
	--Corroboramos si ya existe la linea de producto
	if exists(select 1 from productos.LineaDeProducto where nombre = @nombre)
	begin
		print 'Ya existe una linea de producto con este nombre.'
		return;
	end
	--Insertamos la linea de producto
	insert into productos.LineaDeProducto(nombre)
	values(@nombre);
	--Mostramos por pantalla el id del nuevo medio de pago
    declare @NuevoID int = scope_identity();
    print 'Linea de producto insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));


end;
go

--Creamos el trigger para insetar el precio de referencia por defecto
create or alter trigger productos.SetearPrecioPorDefecto
on productos.Producto
after insert
as
begin
    --Actualizamos el campo precio_referencia con el valor del precio si no se especifico en la inserción
    update productos.Producto
    set precio_referencia = productos.Producto.precio
    from productos.Producto
    inner join Inserted on productos.Producto.id = Inserted.id
    where Inserted.precio_referencia is null;
end;
go

--Creamos el trigger para insertar la fecha por defecto
create or alter trigger productos.SetearFechaPorDefecto
on productos.Producto
after insert
as
begin
	--Actualizamos el campo de la fecha con la fecha actual si no se especifico en la inserccion
	update productos.Producto
	set fecha = (cast(getdate() as smalldatetime)) 
	from  productos.Producto
	inner join Inserted on productos.Producto.id = Inserted.id
	where Inserted.fecha is null
end;
go

--Creamos el store procedure para insertar un producto
create or alter procedure productos.InsertarProducto
	@id_linea_de_producto int,
	@categoria varchar(100),
	@nombre varchar(100),
	@precio decimal(10,2),
	@precio_referencia decimal(10,2) = null,
	@unidad_referencia varchar(50) = 'ud',
	@fecha smalldatetime = null
as
begin
	--Insertamos el producto
	insert into productos.Producto(id_linea_de_producto,categoria,nombre,precio,precio_referencia,unidad_referencia,fecha)
	values(@id_linea_de_producto,@categoria,@nombre,@precio,@precio_referencia,@unidad_referencia,@fecha);
	--Mostramos por pantalla el id del nuevo medio de pago
    declare @NuevoID int = scope_identity();
    print 'Prodcuto insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));

end;
go
