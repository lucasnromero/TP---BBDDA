use g05com2900;
go

create or alter procedure productos.ImportarAccesoriosElectronicos
    @rutaxlsx nvarchar(max),
	@tipodecambio decimal(10,2)
as
begin

    create table productos.#AccesorisElectronicosTemp(
		id int identity(1,1) primary key,
		producto varchar(75),
		precio_unitario_dolares decimal(10,2)
    );

	declare @sql nvarchar(max);

    set @sql = '
        insert into productos.#AccesorisElectronicosTemp(producto, precio_unitario_dolares)
        select [product] as producto, [precio unitario en dolares] as precio_unitario_dolares
        from openrowset(
            ''microsoft.ace.oledb.12.0'',
            ''excel 12.0; database=' + @rutaxlsx + ''',
            ''select * from [sheet1$]''
        )';


    exec sp_executesql @sql;

	-- Insertar los registros desde la tabla temporal a productos.AccesorioElectronico sin duplicados
    insert into productos.AccesorioElectronico (producto, precio_unitario_pesos)
    select 
        producto, 
        precio_unitario_dolares * @tipodecambio  -- Convertir el precio de dólares a pesos
    from productos.#AccesorisElectronicosTemp as temp
    where not exists (
        select 1
        from productos.AccesorioElectronico as p
        where p.id = temp.id
    );

    drop table if exists productos.#AccesorisElectronicosTemp;
    
end;
go

exec productos.ImportarAccesoriosElectronicos @rutaxlsx = 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Productos\Electronic accessories.xlsx', @tipodecambio = 1200

select * from productos.AccesorioElectronico

-- DEBEN CORRERSE ESTOS COMANDOS LUEGO DE INSTALAR LA DISTRIBUCION 2016 DE MICROSOFT ACE --

sp_configure 'show advanced options', 1;
RECONFIGURE;

sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1;
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1;
