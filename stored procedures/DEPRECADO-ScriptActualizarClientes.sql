--DEPRECADO

--Para ejecutar este script primero debio haber ejecutado el script de CreacionClientes


--Nos posicionamos en la base datos
use g05com2900
go




--Creamos el store procedure para actualizar el tipo de cliente del esquema de clientes
create procedure Clientes.ActualizarTipodecliente
    @id int,
    @id_tipo_de_cliente int
as
begin
    -- Corroboramos si existe el cliente 
    if exists (select 1 from clientes.cliente where id = @id)
    begin
        update clientes.cliente
        set
            id_tipo_de_cliente = @id_tipo_de_cliente
        where id = @id;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go





--Creamos el store procedure para actualizar el genero del esquema de clientes
create procedure clientes.ActualizarGenero
    @id int,
    @id_genero int
as
begin
    -- Corroboramos si existe el cliente
    if exists (select 1 from clientes.cliente where id = @id)
    begin
        update clientes.cliente
        set
            id_genero = @id_genero
        where id = @id;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go




--Creamos el store procedure para actualizar la ciudad del esquema de clientes
create procedure clientes.ActualizarCiudad
    @id int,
    @id_ciudad int
as
begin
    -- Corroboramos si existe el cliente
    if exists (select 1 from clientes.cliente where id = @id)
    begin
        update clientes.cliente
        set
            id_ciudad = @id_ciudad
        where id = @id;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go




--Creamos el store procedure para actualizar la direccion del esquema de clientes
create procedure clientes.ActualizarDireccion
    @id int,
    @direccion varchar(50)
as
begin
    -- Corroboramos si existe el cliente
    if exists (select 1 from clientes.cliente where id = @id)
    begin
        update clientes.cliente
        set
            direccion = @direccion
        where id = @id;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go





--Creamos el store procedure para actualizar el nombre del esquema de clientes
create procedure clientes.ActualizarNombre
    @id int,
    @nombre varchar(20)
as
begin
    -- Corroboramos si existe el cliente
    if exists (select 1 from clientes.cliente where id = @id)
    begin
        update clientes.cliente
        set
            nombre = @nombre
        where id = @id;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go





--Creamos el store procedure para actualizar el apellido del esquema de clientes
create procedure clientes.ActualizarApellido
    @id int,
    @apellido varchar(20)
as
begin
    -- Corroboramos si existe el cliente
    if exists (select 1 from clientes.cliente where id = @id)
    begin
        update clientes.cliente
        set
            apellido = @apellido
        where id = @id;
    end
    else
    begin
        print 'El id de cliente ingresado no existe';
    end
end;
go
