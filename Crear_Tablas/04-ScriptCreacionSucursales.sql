--Para ejecutar este script primero debio haber ejecutado el script de CreacionClientes

--Nos posicionamos en la base datos
use g05com2900
go

--Borramos las tablas si existen y las creamos de cero

drop table if exists sucursales.Sucursal
go
drop table if exists sucursales.Empleado
go   

--Preste mucha atencion, no altere el orden de creacion de tablas ya que hay claves foraneas

--Creamos la tabla para las sucursales del esquema sucursales
create table sucursales.Sucursal (
    id int identity(1,1) primary key,
    nombre char(20) not null,
    localidad char(20) not null,
    eliminado bit not null default(0),
    constraint unq_sucursal unique(nombre,localidad)
);
go

--Cramos la tabla para los empleados del esquema sucursales
create table sucursales.Empleado (
    id int identity(1,1) primary key,
    id_genero int,
    id_sucursal int,
    nombre char(20) not null,
    apellido char(20) not null,
    cuil int not null unique,
    fecha_ingreso date not null,
    fecha_egreso date,
    eliminado bit not null default(0),
    direccion char(50),
    constraint fk_genero_empleado foreign key (id_genero) references clientes.Genero(id),
    constraint fk_sucursal foreign key (id_sucursal) references sucursales.Sucursal(id)
);
go
