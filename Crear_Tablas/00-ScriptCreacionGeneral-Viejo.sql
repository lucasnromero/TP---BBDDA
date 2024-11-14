--Fecha de entrega: 05/11
--Número de grupo: 05
--Materia: BASES DE DATOS APLICADAS
--Alumnos:

--42414940 Gonzalez Nazarena Araceli nazgonzalez@alumno.unlam.edu.ar

--43780360 Romero Lucas Nicolas lucasnromero@alumno.unlam.edu.ar 

--43242414 Romano Luciano Javier lromano@alumno.unlam.edu.ar 

--42627797 Burgos Santiago Jesús santburgos@alumno.unlam.edu.ar

--Trabajo práctico Integrador

--Comience usando master y eliminando la base de datos

use master
go

--Eliminar la base de datos si esta creada, si no comente la linea de drop    
drop database g05com2900
go

--Apartir de aqui comienza el script para poder crear la base de datos y todas sus tablas

--Creamos la base de datos
create database g05com2900
go

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los esquemas para incluir las tablas segun categorias

--Craemos el esquema para las ventas
create schema ventas
go

--Creamos el esquema para los productos
create schema productos
go

--Creamos el esquema para las sucursales
create schema sucursales
go

--Craemos el esquema para los clientes
create schema clientes
go

--Preste mucha atencion, no altere el orden de creacion de tablas ya que hay claves foraneas

--Creamos la tabla de tipos de cliente del esquema clientes
create table clientes.TipoDeCliente (
    id int identity(1,1) primary key,
    tipo varchar(15) not null unique
);
go

--Creamos la tabla para las ciudades del esquema clientes
create table clientes.Ciudad (
    id int identity(1,1) primary key,
    nombre varchar(60) not null unique
);
go

--Creamos la tabla para el genero del esquema clientes
create table clientes.Genero (
    id int identity(1,1) primary key,
    tipo varchar(30) not null unique
);
go

--Creamos la tabla para los clientes del esquema clientes
create table clientes.Cliente (
    id int identity(1,1) primary key,
    id_tipo_de_cliente int not null,
    id_ciudad int not null,
    id_genero int not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    dni int not null unique,
    fecha_nacimiento date,
    direccion varchar(60),
    eliminado bit not null default(0),
    constraint fk_tipo_cliente foreign key (id_tipo_de_cliente) references clientes.TipoDeCliente(id),
    constraint fk_ciudad foreign key (id_ciudad) references clientes.Ciudad(id),
    constraint fk_genero_cliente foreign key (id_genero) references clientes.Genero(id)
);
go

--Creamos la tabla para las sucursales del esquema sucursales
create table sucursales.Sucursal (
    id int identity(1,1) primary key,
    ciudad varchar(60) not null,
    localidad varchar(100) not null,
	direccion varchar(100) not null,
	horario varchar(100) not null,
	telefono varchar(20) not null,
    eliminado bit not null default(0),
    constraint unq_sucursal unique(ciudad,localidad)
);
go

--Cramos la tabla para los empleados del esquema sucursales
create table sucursales.Empleado (
    legajo int primary key,
    id_genero int,
    id_sucursal int,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
	email_personal varchar(75) not null,
	email_empresa varchar(75) not null,
	cargo varchar(30) not null,
	turno varchar(30) not null,
    cuil int not null unique,
    eliminado bit not null default(0),
    direccion varchar(100),
    constraint fk_genero_empleado foreign key (id_genero) references clientes.Genero(id),
    constraint fk_sucursal foreign key (id_sucursal) references sucursales.Sucursal(id)
);
go

--Creamos la tabla para los medios de pago del esquema ventas
create table ventas.MedioDePago (
    id int identity(1,1) primary key,
    tipo varchar(40) not null unique
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
    constraint fk_empleado foreign key (id_empleado) references sucursales.Empleado(legajo),
    constraint fk_sucursal_venta foreign key (id_sucursal) references sucursales.Sucursal(id),
    constraint fk_medio_de_pago foreign key (id_medio_de_pago) references ventas.MedioDePago(id),
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

--Creamos la tabla para las lineas de producto del esquema productos
create table productos.LineaDeProducto (
    id int identity(1,1) primary key,
    nombre varchar(100) not null unique
);
go

--Creamos la tabla para los productos del esquema productos
create table productos.Producto (
    id int identity(1,1) primary key,
    id_linea_de_producto int,
    nombre_producto varchar(100) not null,
    precio decimal(10,2) not null,
    constraint fk_linea_de_producto foreign key (id_linea_de_producto) references productos.LineaDeProducto(id)
);
go

--Creamos la tabla para los catalogos que vienen como archivos del esquema productos
create table productos.Catalogo (
    id int primary key,
    categoria varchar(100),
    nombre varchar(100),
    precio decimal(8,2),
    precio_referencia decimal(10,2),
    unidad_referencia varchar(10),
    fecha datetime
);
go

--Creamos la tabla para los accesorios electronicos que vienen como archivos del esquema productos
create table productos.AccesorioElectronico (
    id int identity(1,1) primary key,
    producto varchar(100),
    precio_unitario_pesos decimal(10,2)
);
go

--Creamos la tabla para los productos importados que vienen como archivos del esquema productos
create table productos.ProductoImportado (
    id_producto int primary key,
    cantidad_por_unidad varchar(100),
    nombre varchar(100),
    categoria varchar(100),
    proveedor varchar(100),
    precio_por_unidad decimal(10,2)
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
