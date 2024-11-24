--DEPRECADO

use g05com2900

go

-- Procedimiento almacenado para eliminar un medio de pago por ID
create or alter procedure ventas.EliminarMedioDePago
    @id int
as
begin
    -- Verificar si el medio de pago existe
    if not exists(select 1 from ventas.MedioDePago where id = @id)
    begin
        print 'No se encontró el medio de pago con el ID especificado.';
        return;
    end

    -- Eliminar el medio de pago
    delete from ventas.MedioDePago where id = @id;

    print 'Medio de Pago eliminado correctamente.';
end;

go

-- Procedimiento almacenado para eliminar un tipo de factura por ID
create or alter procedure ventas.EliminarTipoDeFactura
    @id int
as
begin
    -- Verificar si el tipo de factura existe
    if not exists(select 1 from ventas.TipoDeFactura where id = @id)
    begin
        print 'No se encontró el tipo de factura con el ID especificado.';
        return;
    end

    -- Eliminar el tipo de factura
    delete from ventas.TipoDeFactura where id = @id;

    print 'Tipo de Factura eliminado correctamente.';
end;

go
