--DEPRECADO



--Para ejecutar este script primero debio haber ejecutado el script de CreacionSucursales, CreacionProductos y CreacionClientes

--Nos posicionamos en la base datos
use g05com2900
go

--Borramos las tablas si existen y las creamos de cero

drop table if exists ventas.MedioDePago
go
drop table if exists ventas.Venta
go
drop table if exists ventas.TipoDeFactura
go
drop table if exists ventas.Factura
go  
drop table if exists ventas.LineaDeVenta
go

--Preste mucha atencion, no altere el orden de creacion de tablas ya que hay claves foraneas

--Creamos la tabla para los medios de pago del esquema ventas
create table ventas.MedioDePago (
    id int identity(1,1) primary key,
    descripcion char(30) not null unique
);
go

--Creamos la tabla para las ventas del esquema ventas
create table ventas.Venta (
    id int identity(1,1) primary key,
    id_cliente int,
    id_empleado int,
    id_sucursal int,
    id_medio_de_pago int,
    total decimal(10,2) check (total >=0),
    cantidad_de_productos int check (cantidad_de_productos >= 0),
    fecha date,
    hora time(0),
    constraint fk_cliente foreign key (id_cliente) references clientes.Cliente(id),
    constraint fk_empleado foreign key (id_empleado) references sucursales.Empleado(id),
    constraint fk_sucursal_venta foreign key (id_sucursal) references sucursales.Sucursal(id),
    constraint fk_medio_de_pago foreign key (id_medio_de_pago) references ventas.MedioDePago(id)
);
go

--Creamos la tabla para los tipos de factura del esquema ventas
create table ventas.TipoDeFactura (
    id int identity(1,1) primary key,
    tipo char(1) not null unique check(tipo like '[A-Z]')
);
go

--Creamos la tabla para las facturas del esquema ventas
create table ventas.Factura (
    id int identity(1,1) primary key,
    id_venta int,
    id_tipo_de_factura int,
    constraint fk_venta_factura foreign key (id_venta) references ventas.Venta(id),
    constraint fk_tipo_de_factura foreign key (id_tipo_de_factura) references ventas.TipoDeFactura(id)
);
go

--Creamos la tabla para las lineas de venta del esquema ventas
create table ventas.LineaDeVenta (
    id int identity(1,1) primary key,
    id_venta int,
    id_producto int,
    id_catalogo int,
    id_producto_importado int,
    id_accesorio int,
    can_producto int default 0 check (can_producto >= 0),
    pre_producto decimal(10,2) default 0 check (pre_producto >= 0),
    sub_producto as (can_producto * pre_producto) persisted,
    can_catalogo int default 0 check (can_catalogo >= 0),
    pre_catalogo decimal(10,2) default 0 check (pre_catalogo >= 0),
    sub_catalogo as (can_catalogo * pre_catalogo) persisted,
    can_accesorio int default 0 check (can_accesorio >= 0),
    pre_accesorio decimal(10,2) default 0 check (pre_accesorio >= 0),
    sub_accesorio as (can_accesorio * pre_accesorio) persisted,
    can_producto_importado int default 0 check (can_producto_importado >= 0),
    pre_producto_importado decimal(10,2) default 0 check (pre_producto_importado >= 0),
    sub_producto_importado as (can_producto_importado * pre_producto_importado) persisted,
    constraint fk_venta_linea foreign key (id_venta) references ventas.Venta(id),
    constraint fk_producto_linea foreign key (id_producto) references productos.Producto(id),
    constraint fk_catalogo_linea foreign key (id_catalogo) references productos.Catalogo(id),
    constraint fk_producto_importado_linea foreign key (id_producto_importado) references productos.ProductoImportado(id_producto),
    constraint fk_accesorio_linea foreign key (id_accesorio) references productos.AccesorioElectronico(id),
    constraint unq_venta_producto unique (id_venta, id_producto),
    constraint unq_venta_producto_importado unique (id_venta, id_producto_importado),
    constraint unq_venta_catalogo unique (id_venta, id_catalogo),
    constraint unq_venta_accesorio unique (id_venta, id_accesorio)
);
go
