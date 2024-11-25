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
			''select [Línea de producto], [Producto] from [Clasificacion productos$]'');
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
		reemplazo varchar(60),
        ciudad varchar(60),
        direccion varchar(100),
        horario varchar(100),
        telefono varchar(20)
    );
    declare @sql nvarchar(max);
    --Preparamos la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into #SucursalTemp(reemplazo, ciudad, direccion, horario, telefono)
        select [Ciudad], [Reemplazar por], [direccion], [Horario], [Telefono]
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [sucursal$]'');
		';
    --Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
	--Insertamos las ciudad sin repetir
	insert into clientes.Ciudad (reemplazo,nombre)
	select t.reemplazo,t.ciudad
	from #SucursalTemp as t
	where not exists (select 1 from clientes.Ciudad as c
	where c.nombre = t.ciudad);
	--Creamos una tabla temporal para actualizar luego los cuits
	 create table #NuevasSucursales (
        id int
    );
    --Insertamos los registros desde la tabla temporal a sucursales.Sucursal sin duplicados
    insert into sucursales.Sucursal (id_ciudad, direccion, horario, telefono)
    output inserted.id into #NuevasSucursales(id)
    select (select id from clientes.Ciudad where nombre = t.ciudad), t.direccion, t.horario, t.telefono
    from #SucursalTemp as t
    where not exists (
        select 1
        from sucursales.Sucursal as s
        where s.direccion = t.direccion
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
            ''select * from [Empleados$A1:K17]'');
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
		(select s.id from sucursales.Sucursal as s inner join clientes.Ciudad as c on s.id_ciudad = c.id where c.nombre = t.sucursal) 
    from #EmpleadoTemp as t
    --Juntamos con la tabla de TipoDeCargo
    inner join sucursales.TipoDeCargo as cargo on cargo.tipo = t.cargo
    --Juntamos con la tabla de Turno
    inner join sucursales.Turno as turno on turno.turno = t.turno
    --Evitamos los duplicados en la tabla Empleado
    where not exists (select 1 from sucursales.Empleado as e
    where e.legajo = t.legajo);
    --Eliminamos la tabla temporal
    drop table if exists #EmpleadoTemp;   
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
            ''select * from [medios de pago$B2:B100]'');
		';
	--Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
    --Insertamos los registros válidos en la tabla de MedioDePago
    insert into ventas.MedioDePago (tipo)
    select tipo
    from #MedioDePagoTemp as t
	where not exists ( select 1 from ventas.MedioDePago as m
	where m.tipo = t.tipo);
    --Eliminamos la tabla temporal
    drop table if exists #MedioDePagoTemp;
end;
go
--Ejecutamos el procedimiento con el archivo especificado
exec ventas.ImportarMedioDePago @rutaxlsx = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Informacion_complementaria.xlsx';
go

--Creamos el store procedure para importar los accesorios electronicos
create or alter procedure productos.ImportarAccesoriosElectronicos
    @rutaxlsx nvarchar(max),
	@tipodecambio decimal(10,2)
as
begin
	--Creamos tabla temporal para almacenar los datos del Excel
    create table #ProductosTemp(
		nombre varchar(100),
		precio_unitario_dolares decimal(10,2)
    );
	declare @sql nvarchar(max);
	--Preparamos la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into #ProductosTemp(nombre, precio_unitario_dolares)
        select [Product] as nombre, [Precio Unitario en dolares] as precio_unitario_dolares
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [sheet1$]'');
		';
	--Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
	--Insertamos la nueva linea que viene de estos productos que estamos importando
	insert into productos.LineaDeProducto(linea,categoria)
	select 'Electronic Accessories','Electrodomesticos'
	where not exists (select 1 from productos.LineaDeProducto as p
    where p.linea = 'Electronic Accessories' and p.categoria = 'Electrodomesticos');
	--Insertamos los registros desde la tabla temporal a la de Productos sin duplicados
    insert into productos.Producto(id_linea_de_producto,nombre,precio,unidad_referencia)
    select 
        (select id from productos.LineaDeProducto where linea = 'Electronic Accessories'), 
		t.nombre,
        t.precio_unitario_dolares * @tipodecambio,  --Convertimos el precio de dólares a pesos
		'ud'
	from #ProductosTemp as t 
	where not exists (select 1 from productos.Producto as p
    where p.nombre = t.nombre);
	--Eliminamos la tabla temporal
    drop table if exists #ProductosTemp;
end;
go
--Ejecutamos el procedimiento con el archivo especificado
exec productos.ImportarAccesoriosElectronicos @rutaxlsx = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Productos\Electronic accessories.xlsx', @tipodecambio = 1200
go

--Creamos el store procedure para importar los productos importados
create or alter procedure productos.ImportarProductosImportados
    @rutaxlsx nvarchar(max)
as
begin
    --Creamos la tabla temporal para almacenar los datos del Excel
    create table #ProductosTemp(
        NombreProducto varchar(100),
        Categoria varchar(100),
        CantidadPorUnidad varchar(100),
        PrecioUnidad decimal(10,2)
    );
    declare @sql nvarchar(max);
    --Preparamos la consulta dinámica para leer el Excel usando OPENROWSET
    set @sql = '
        insert into #ProductosTemp(NombreProducto, Categoria, CantidadPorUnidad, PrecioUnidad)
        select [NombreProducto], [Categoría], [CantidadPorUnidad], [PrecioUnidad]
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [Listado de Productos$]'');
	   ';
    --Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
	--Insertamos las lineas de producto que vienen de estos productos que estamos importando
	insert into productos.LineaDeProducto(linea,categoria)
	select distinct 'Productos Importados',t.Categoria
	from #ProductosTemp as t
	where not exists (select 1 from productos.LineaDeProducto as p
    where p.linea = 'Productos Importados' and p.categoria = t.Categoria);
    --Insertamos los registros desde la tabla temporal a la de Productos sin duplicados
    insert into productos.Producto (id_linea_de_producto, nombre, precio, unidad_referencia)
    select
		(select id from productos.LineaDeProducto where linea = 'Productos Importados' and categoria = t.Categoria),
        t.NombreProducto, 
        t.PrecioUnidad,
		t.CantidadPorUnidad
    from #ProductosTemp as t
    where not exists (
        select 1
        from productos.Producto as p
        where p.nombre = t.NombreProducto
    );
    --Eliminamos la tabla temporal
    drop table if exists #ProductosTemp;
end;
go
--Ejecutamos el procedimiento con el archivo y tipo de cambio especificados
exec productos.ImportarProductosImportados @rutaxlsx = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Productos\Productos_importados.xlsx'
go

--Creamos el store procedure para importar el catalogo
create or alter procedure productos.ImportarCatalogo
    @rutacsv nvarchar(max)
as
begin
	--Creamos la tabla temporal para almacenar los datos del CSV
    create table #ProductosTemp(
		id int,
        categoria varchar(40),
        nombre nvarchar(100),
        precio decimal(10,2),
        precio_referencia decimal(10,2),
        unidad_referencia varchar(50),
        fecha smalldatetime
    );
    declare @sql nvarchar(max);
	--Preparamos la consulta dinámica para leer el Excel usando bulk insert
    set @sql = '
        bulk insert #ProductosTemp
        from ''' + @rutacsv + '''
        with (
            format = ''csv'',
            fieldterminator = '','',
            rowterminator = ''0x0a'',
            firstrow = 2,
            codepage = ''65001''
        )';
	--Ejecutamos la consulta dinámica
    exec sp_executesql @sql;
	--Insertamos los registros desde la tabla temporal a la de Productos sin duplicados
    insert into productos.Producto(id_linea_de_producto, nombre, precio, precio_referencia, unidad_referencia, fecha)
    select (select id from productos.LineaDeProducto where categoria = t.categoria ), t.nombre, t.precio, t.precio_referencia, t.unidad_referencia, t.fecha
    from #ProductosTemp as t
    where not exists (select 1 from productos.Producto as p
    where p.nombre = t.nombre);
	--Elminamos la tabla temporal
    drop table if exists #ProductosTemp;
end;
go
--Ejecutamos el procedimiento con el archivo y tipo de cambio especificados
exec productos.ImportarCatalogo @rutacsv = 'C:\Users\lucia\Desktop\Bases\TP_integrador_Archivos\Productos\catalogo.csv'; 
go

--Creamos el store procedure para importar las ventas
create or alter procedure ventas.ImportarVentas
    @rutacsv nvarchar(max)
as
begin
    --Creamos la tabla temporal para almacenar los datos del CSV
    create table #VentasTemp(
        codigo varchar(50),
        tipo_factura varchar(50),
        ciudad varchar(100),
        tipo_cliente varchar(50),
        genero varchar(20),
        producto nvarchar(100),
        precio_unitario varchar(20),
        cantidad varchar(20),
        fecha varchar(20),
        hora varchar(20),
        medio_pago varchar(50),
        empleado varchar(50),
        identificador_pago varchar(50)
    );
    declare @sql nvarchar(max);
    --Preparamos la consulta dinámica para leer el Excel usando bulk insert
    set @sql = '
        bulk insert #VentasTemp
        from ''' + @rutacsv + '''
        with (
            format = ''csv'',
            fieldterminator = '';'', -- Utilizar tabulación como separador
            rowterminator = ''0x0a'', -- Salto de línea
            firstrow = 2, -- Ignorar encabezado
            codepage = ''65001'' -- Soporte para UTF-8);
	  ';
    --Ejecutamos la consulta dinámica
	exec sp_executesql @sql;
	--Declaramos las variables para almacenar los IDs generados
    declare @id_venta int, @id_factura int,@id_tipo_de_factura int, @id_producto int, @id_medio int, 
			@id_ciudad int, @id_tipo_de_cliente int, @id_genero int, @id_sucursal int, @id_cliente int,
			@cuit varchar(20);
	--Declaramos las variables de los campos de la tabla temporal
	declare @codigo varchar(50), @tipo_factura varchar(50), @ciudad varchar(100), @tipo_cliente varchar(50), @genero varchar(20), @producto varchar(100), 
        @precio_unitario int, @cantidad int, @fecha date, @hora time, @medio_pago varchar(50), @empleado int, @identificador_pago varchar(50);
    --Declaramos un cursor para analizar venta por venta
    declare cursor_ventas cursor for
    select 
        codigo, tipo_factura, ciudad, tipo_cliente, genero, producto, 
        precio_unitario, cantidad, fecha, hora, medio_pago, empleado, identificador_pago
    from #VentasTemp;
	--Abrimos el cursor y comenzamos con el bucle
    open cursor_ventas;
    fetch next from cursor_ventas into 
        @codigo, @tipo_factura, @ciudad, @tipo_cliente, @genero, @producto, 
        @precio_unitario, @cantidad, @fecha, @hora, @medio_pago, @empleado, @identificador_pago;
    while @@FETCH_STATUS = 0
    begin
        --Obtenemos el id de la ciudad
        select @id_ciudad = id from clientes.Ciudad where reemplazo = @ciudad;
        --Obtenemos el id del tipo de cliente o insertamos si no lo encuentra
        select @id_tipo_de_cliente = id from clientes.TipoDeCliente where tipo = @tipo_cliente;
        if @id_tipo_de_cliente is null
        begin
            insert into clientes.TipoDeCliente (tipo) values (@tipo_cliente);
            set @id_tipo_de_cliente = scope_identity();
        end;
		--Obtenemos el id del genero o insertamos si no lo encuentra
        select @id_genero = id from clientes.Genero where tipo = @genero;
        if @id_genero is null
        begin
            insert into clientes.Genero (tipo) values (@genero);
            set @id_genero = scope_identity();
        end;
		--Insertamos el cliente nuevo con sus campos de genero, ciudad y tipo de cliente. Y obtenemos su id
		insert into clientes.Cliente(id_tipo_de_cliente,id_genero,id_ciudad)
		values(@id_tipo_de_cliente,@id_genero,@id_ciudad);
		set @id_cliente = scope_identity();
		--Obtenemos el id del medio de pago o insertamos si no lo encuentra
        select @id_medio = id from ventas.MedioDePago where tipo = @medio_pago;
        if @id_medio is null
        begin
            insert into ventas.MedioDePago (tipo) values (@medio_pago);
            set @id_medio = scope_identity();
        end;
		--Obtenemos el id del producto
        select @id_producto = id from productos.Producto where nombre = @producto;
		--Obtenemos el id del tipo de factura o insertamos si no lo encuentra
		select @id_tipo_de_factura = id from ventas.TipoDeFactura where tipo = @tipo_factura;
		if @id_tipo_de_factura is null
		begin
			insert into ventas.TipoDeFactura(tipo) values(@tipo_factura);
			set @id_tipo_de_factura = scope_identity();
		end;
		--Obtenemos el cuit de la sucursal
		select @cuit = s.cuit from sucursales.Sucursal as s inner join sucursales.Empleado as e on e.id_sucursal = s.id where e.legajo = @empleado;
        --Insertamos la venta
        insert into ventas.Venta (id_cliente, legajo_empleado, total, cantidad_de_productos, fecha, hora)
        values (@id_cliente, @empleado, @precio_unitario * @cantidad, @cantidad, @fecha, @hora);
        set @id_venta = scope_identity();
        --Insertamos el detalle de la venta
        insert into ventas.DetalleDeVenta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
        values (@id_venta, @id_producto, @cantidad, @precio_unitario, @precio_unitario * @cantidad);
        --Insertamos la factura
        insert into ventas.Factura (id_venta, id_tipo_de_factura, total_iva, cuit, estado)
        values (@id_venta,@id_tipo_de_factura,@precio_unitario * @cantidad * 1.21 , @cuit, 'Pagada');
        set @id_factura = scope_identity();
        --Insertamos el pago
        insert into ventas.Pago (id_factura, identificador, id_medio, monto, fecha)
        values (@id_factura, @identificador_pago, @id_medio, @precio_unitario * @cantidad * 1.21, cast(cast(@fecha as datetime) + cast(@hora as datetime) as smalldatetime));
		--Siguiente iteracion
    fetch next from cursor_ventas into 
        @codigo, @tipo_factura, @ciudad, @tipo_cliente, @genero, @producto, 
        @precio_unitario, @cantidad, @fecha, @hora, @medio_pago, @empleado, @identificador_pago;
    end
	--Cerramos y eliminamos el cursor
    close cursor_ventas;
    deallocate cursor_ventas;
    --Eliminamos la tabla temporal
    drop table if exists #VentasTemp;
end;
go

