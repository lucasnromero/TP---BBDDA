--DEPRECADO

--Para ejecutar este script primero debio haber ejecutado el script de CreacionVentas

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los store procedures de inserccion para el esquema de ventas

--Creamos el store procedure para insertar los medios de pago
create or alter procedure ventas.InsertarMedioDePago
    @descripcion char(30)
as
begin
    --Corroboramos si ya existe el medio de pago 
    if exists(select 1 from ventas.MedioDePago where descripcion = @descripcion)
    begin  
        print 'Ya existe un medio de pago con esa decripcion.'
        return;
    end
    --Insertamos el nuevo medio de pago
    insert into ventas.MedioDePago (descripcion)
    values (@descripcion);
    --Mostramos por pantalla el id del nuevo medio de pago
    declare @NuevoID int = scope_identity();
    print 'Medio de pago insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar los tipos de factura
create or alter procedure ventas.InsertarTipoDeFactura
    @tipo char(1)
as
begin
    --Corroboramos si ya existe el tipo de factura 
    if exists(select 1 from ventas.TipoDeFactura where tipo = @tipo)
    begin  
        print 'Ya existe ese tipo de factura.'
        return;
    end
    --Insertamos el nuevo tipo de factura
    insert into ventas.TipoDeFactura (tipo)
    values (@tipo);
    --Mostramos por pantalla el id del nuevo tipo de factura
    declare @NuevoID int = scope_identity();
    print 'Tipo de factura insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go
