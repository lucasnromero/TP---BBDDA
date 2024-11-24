--Fecha de entrega: 26/11
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

--Elimina la base de datos si esta creada    
drop database if exists g05com2900
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
    id_tipo_de_cliente int,
    id_ciudad int,
    id_genero int,
    nombre varchar(50),
    apellido varchar(50),
    dni int,
    fecha_nacimiento date,
    direccion varchar(60),
    eliminado bit not null default(0),
    constraint fk_tipo_cliente foreign key (id_tipo_de_cliente) references clientes.TipoDeCliente(id) on delete set null,
    constraint fk_ciudad foreign key (id_ciudad) references clientes.Ciudad(id) on delete set null,
    constraint fk_genero_cliente foreign key (id_genero) references clientes.Genero(id) on delete set null
);
go

--Creamos la tabla para las sucursales del esquema sucursales
create table sucursales.Sucursal (
    id int identity(1,1) primary key,
    ciudad varchar(60) not null,
	direccion varchar(100) not null,
	horario varchar(100) not null,
	telefono varchar(20) not null,
	cuit varchar(20),
    eliminado bit not null default(0)
);
go

--Creamos la tabla para los cargos del esquema de sucursales
create table sucursales.TipoDeCargo ( 
	id int identity(1,1) primary key,
	tipo varchar(40) not null unique
);
go

--Creamos la tabla para los turnos del esquema de sucursales
create table sucursales.Turno (
	id int identity(1,1) primary key,
	turno varchar(30) not null unique
);
go

--Cramos la tabla para los empleados del esquema sucursales
create table sucursales.Empleado (
    legajo int primary key,
    id_genero int,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
	dni int not null,
	direccion varchar(100) not null,
	email_personal varchar(75) not null,
	email_empresa varchar(75) not null,
    cuil varchar(15) unique,
	id_cargo int,
	id_sucursal int,
	id_turno int,
    eliminado bit not null default(0),
    constraint fk_genero_empleado foreign key (id_genero) references clientes.Genero(id) on delete set null,
    constraint fk_sucursal foreign key (id_sucursal) references sucursales.Sucursal(id) on delete set null,
	constraint fk_cargo foreign key (id_cargo) references sucursales.TipoDeCargo(id) on delete set null,
	constraint fk_turno foreign key (id_turno) references sucursales.Turno on delete set null
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
    legajo_empleado int,
    id_sucursal int,
    total decimal(10,2) check (total >=0),
	cantidad_de_productos int check (cantidad_de_productos >= 0),
    fecha date default (cast(getdate() as date)),
    hora time(0) default (cast(getdate() as time)),
    constraint fk_cliente foreign key (id_cliente) references clientes.Cliente(id) on delete set null,
    constraint fk_empleado foreign key (legajo_empleado) references sucursales.Empleado(legajo) on delete set null,
    constraint fk_sucursal_venta foreign key (id_sucursal) references sucursales.Sucursal(id) on delete set null,    
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
	codigo varchar(50) default null,
    id_venta int not null,
    id_tipo_de_factura int,
	total_iva decimal(10,2) check(total_iva >=0),
	cuit varchar(20),
	estado varchar(30) check(estado in ('Pagada','Pendiente')) default('Pendiente'),
    constraint fk_venta_factura foreign key (id_venta) references ventas.Venta(id),
    constraint fk_tipo_de_factura foreign key (id_tipo_de_factura) references ventas.TipoDeFactura(id) on delete set null
);
go

--Creamos la tabla para los pagos del esquema ventas
create table ventas.Pago (
	id int identity(1,1) primary key,
	id_factura int,
	identificador varchar(30),
	id_medio int,
	monto decimal(10,2),
	fecha smalldatetime default(cast(getdate()as smalldatetime)),
	constraint fk_medio_pago foreign key (id_medio) references ventas.MedioDePago(id),
	constraint fk_factura_pago foreign key (id_factura) references ventas.Factura(id)
);
go

--Creamos la tabla para las notas de credito del esquema ventas
create table ventas.NotaDeCredito (
	id int identity(1,1),
	id_factura int not null,
	motivo varchar(100),
	monto decimal(10,2),
	fecha smalldatetime default(cast(getdate() as smalldatetime)),
	constraint fk_factura_nota foreign key (id_factura) references ventas.Factura(id)
);
go

--Creamos la tabla para las lineas de producto del esquema productos
create table productos.LineaDeProducto (
    id int identity(1,1) primary key,
    nombre varchar(50) not null unique
);
go

--Creamos la tabla para los productos del esquema productos
create table productos.Producto (
    id int identity(1,1) primary key,
    id_linea_de_producto int,
    categoria varchar(100),
	nombre varchar(100) not null,
	precio decimal(10,2) not null,
	precio_referencia decimal(10,2),
	unidad_referencia varchar(50),
	fecha smalldatetime,
    constraint fk_linea_de_producto foreign key (id_linea_de_producto) references productos.LineaDeProducto(id) on delete set null
);
go

--Creamos la tabla para las lineas de venta del esquema ventas
create table ventas.DetalleDeVenta (
    id int identity(1,1) primary key,
    id_venta int not null,
	id_producto int,
	cantidad int check(cantidad >=1),
	precio_unitario decimal(10,2),
	subtotal decimal(10,2),
	constraint fk_venta_detalle foreign key (id_venta) references ventas.Venta(id),
	constraint fk_producto_detalle foreign key (id_producto) references productos.Producto(id) on delete set null
);
go
