--DEPRECADO

use g05com2900
go

create or alter procedure productos.ImportarProductos
    @rutaxlsx nvarchar(255)
as
begin
    -- Crear una tabla temporal para cargar los datos desde el archivo de Excel
    create table #temp_clasificacion_productos (
        linea_de_producto varchar(100),
        producto varchar(100)
    );

	declare @sql nvarchar(max);

	set @sql = '
		insert into #temp_clasificacion_productos (linea_de_producto, producto)
		select [Línea de producto] as linea_de_producto, [Producto] as producto
		from openrowset(
			''microsoft.ace.oledb.12.0'',
			''excel 12.0;database=' + @rutaxlsx + ';hdr=yes;'',
			''select [Línea de producto], [Producto] from [Clasificacion productos$]''
		);
	';

	exec sp_executesql @sql;

    -- Insertar las líneas de producto únicas en la tabla productos.LineaDeProducto
    insert into productos.LineaDeProducto (nombre)
    select distinct linea_de_producto
    from #temp_clasificacion_productos
    where linea_de_producto is not null
      and linea_de_producto <> ''
      and linea_de_producto not in (select nombre from productos.lineadeproducto);

    -- Insertar los productos en la tabla productos.Producto con la relación a la línea de producto
    insert into productos.Producto (id_linea_de_producto, nombre_producto, precio)
    select lp.id, tc.producto, 0.00 -- Asignamos un precio predeterminado de 0.00
    from #temp_clasificacion_productos tc
    join productos.LineaDeProducto lp on tc.linea_de_producto = lp.nombre
    where tc.producto is not null
      and tc.producto <> ''
      and not exists (
          select 1
          from productos.producto p
          where p.nombre_producto = tc.producto
            and p.id_linea_de_producto = lp.id
      );

    -- Limpiar la tabla temporal
    drop table #temp_clasificacion_productos;
end;
go

select * from productos.LineaDeProducto
select * from productos.Producto

exec productos.ImportarProductos @rutaxlsx = 'C:\Users\Lucas\Desktop\TP BBDDA\TP_integrador_Archivos\TP_integrador_Archivos\Informacion_complementaria.xlsx';
