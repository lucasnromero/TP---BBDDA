--DEPRECADO

--Nos posicionamos en la base datos
use g05com2900
go

--Borramos las tablas si existen y las creamos de cero

drop table if exists clientes.TipoDeCliente
go
drop table if exists clientes.Ciudad
go 
drop table if exists clientes.Genero
go 
drop table if exists clientes.Cliente
go  

--Preste mucha atencion, no altere el orden de creacion de tablas ya que hay claves foraneas

--Creamos la tabla de tipos de cliente del esquema clientes
create table clientes.TipoDeCliente (
    id int identity(1,1) primary key,
    tipo char(15) not null unique
);
go

--Creamos la tabla para las ciudades del esquema clientes
create table clientes.Ciudad (
    id int identity(1,1) primary key,
    nombre char(20) not null unique
);
go

--Creamos la tabla para el genero del esquema clientes
create table clientes.Genero (
    id int identity(1,1) primary key,
    tipo char(10) not null unique
);
go

--Creamos la tabla para los clientes del esquema clientes
create table clientes.Cliente (
    id int identity(1,1) primary key,
    id_tipo_de_cliente int not null,
    id_ciudad int not null,
    id_genero int not null,
    nombre char(20) not null,
    apellido char(20) not null,
    dni int not null unique,
    fecha_nacimiento date,
    direccion char(50),
    eliminado bit not null default(0),
    constraint fk_tipo_cliente foreign key (id_tipo_de_cliente) references clientes.TipoDeCliente(id),
    constraint fk_ciudad foreign key (id_ciudad) references clientes.Ciudad(id),
    constraint fk_genero_cliente foreign key (id_genero) references clientes.Genero(id)
);
go
