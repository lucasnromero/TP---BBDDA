--DEPRECADO

--Para ejecutar este script primero debio haber ejecutado el script de CreacionClientes

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
    @nombre varchar(50),
    @apellido varchar(50),
    @dni int,
    @fecha_nacimiento date,
    @direccion varchar(60)
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
