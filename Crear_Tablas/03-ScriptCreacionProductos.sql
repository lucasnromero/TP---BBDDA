--Nos posicionamos en la base datos
use g05com2900
go

--Borramos las tablas si existen y las creamos de cero

drop table if exists productos.LineaDeProducto
go
drop table if exists productos.Producto
go
drop table if exists productos.Catalogo
go
drop table if exists productos.AccesorioElectronico
go  
drop table if exists productos.ProductoImportado
go

--Preste mucha atencion, no altere el orden de creacion de tablas ya que hay claves foraneas

--Creamos la tabla para las lineas de producto del esquema productos
create table productos.LineaDeProducto (
    id int identity(1,1) primary key,
    nombre char(30) not null unique
);
go

--Creamos la tabla para los productos del esquema productos
create table productos.Producto (
    id int identity(1,1) primary key,
    id_linea_de_producto int,
    nombre_producto char(30) not null,
    precio decimal(10,2) not null,
    constraint fk_linea_de_producto foreign key (id_linea_de_producto) references productos.LineaDeProducto(id)
);
go

--Creamos la tabla para los catalogos que vienen como archivos del esquema productos
create table productos.Catalogo (
    id int primary key,
    categoria char(30),
    nombre char(50),
    precio decimal(8,2),
    precio_referencia decimal(10,2),
    unidad_referencia char(2),
    fecha datetime
);
go

--Creamos la tabla para los accesorios electronicos que vienen como archivos del esquema productos
create table productos.AccesorioElectronico (
    id int identity(1,1) primary key,
    producto char(50),
    precio_unitario_dolares decimal(10,2)
);
go

--Creamos la tabla para los productos importados que vienen como archivos del esquema productos
create table productos.ProductoImportado (
    id_producto int primary key,
    cantidad_por_unidad char(40),
    nombre char(50),
    categoria char(30),
    proveedor char(50),
    precio_por_unidad decimal(10,2)
);
go