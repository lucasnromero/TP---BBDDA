use g05com2900
go

-- Procedimiento almacenado para eliminar una ciudad
create or alter procedure clientes.EliminarCiudad
    @id int
as
begin
    -- Verificamos si la ciudad existe
    if not exists(select 1 from clientes.Ciudad where id = @id)
    begin
        print 'No se encontró la ciudad con el ID especificado.';
        return;
    end

    -- Eliminamos la ciudad
    delete from clientes.Ciudad where id = @id;

    print 'Ciudad eliminada correctamente con ID: ' + cast(@id as varchar(4));
end;


go


-- Procedimiento almacenado para eliminación lógica de un cliente
create or alter procedure clientes.EliminarCliente
    @id int
as
begin
    -- Verificamos si el cliente existe
    if not exists(select 1 from clientes.Cliente where id = @id)
    begin
        print 'No se encontró el cliente con el ID especificado.';
        return;
    end

    -- Realizamos el borrado lógico
    update clientes.Cliente set eliminado = 1 where id = @id;

    print 'Cliente marcado como eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;

go

-- Procedimiento almacenado para eliminar un tipo de cliente
create or alter procedure clientes.EliminarTipoDeCliente
    @id int
as
begin
    -- Verificamos si el tipo de cliente existe
    if not exists(select 1 from clientes.TipoDeCliente where id = @id)
    begin
        print 'No se encontró el tipo de cliente con el ID especificado.';
        return;
    end

    -- Eliminamos el tipo de cliente
    delete from clientes.TipoDeCliente where id = @id;

    print 'Tipo de cliente eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;

go

-- Procedimiento almacenado para eliminar un género
create or alter procedure clientes.EliminarGenero
    @id int
as
begin
    -- Verificamos si el género existe
    if not exists(select 1 from clientes.Genero where id = @id)
    begin
        print 'No se encontró el género con el ID especificado.';
        return;
    end

    -- Eliminamos el género
    delete from clientes.Genero where id = @id;

    print 'Género eliminado correctamente con ID: ' + cast(@id as varchar(4));
end;

go

