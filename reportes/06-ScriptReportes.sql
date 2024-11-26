--Nos posicionamos en la base datos
use g05com2900
go

--Creamos la vista del reporte Futuro que incluye una venta completa
create or alter view ventas.VentaCompleta as
select 
    f.codigo as 'ID Factura',
    tf.tipo as 'Tipo de Factura',
    c.nombre as Ciudad,
    tc.tipo as 'Tipo de Cliente',
    g.tipo as Genero,
    lp.linea as 'Linea de Producto',
    p.nombre as Producto,
    dv.precio_unitario as 'Precio Unitario',
    dv.cantidad as Cantidad,
    dv.subtotal as Costo,
    v.fecha as Fecha,
    v.hora as Hora,
    mp.tipo as 'Medio de Pago',
    e.legajo as Empleado,
    (select nombre from clientes.Ciudad c where c.id = s.id_ciudad) as Sucursal
from ventas.Factura f
inner join ventas.Venta v on f.id_venta = v.id
inner join clientes.Cliente cli on v.id_cliente = cli.id
inner join clientes.Ciudad c on cli.id_ciudad = c.id
inner join clientes.TipoDeCliente tc on cli.id_tipo_de_cliente = tc.id
inner join clientes.Genero g on cli.id_genero = g.id
inner join ventas.DetalleDeVenta dv on v.id = dv.id_venta
inner join productos.Producto p on dv.id_producto = p.id
inner join productos.LineaDeProducto lp on p.id_linea_de_producto = lp.id
inner join ventas.Pago pag on pag.id_factura = f.id
inner join ventas.MedioDePago mp on mp.id = pag.id_medio
inner join ventas.TipoDeFactura tf on f.id_tipo_de_factura = tf.id
left join sucursales.Empleado e on v.legajo_empleado = e.legajo
left join sucursales.Sucursal s on e.id_sucursal = s.id;
go

--Creamos el store procedure para generar el xml del reporte de ventas completas
create or alter procedure ventas.ReporteVentaCompleta
as
begin
	select 
    [ID Factura] as 'Factura/ID',
    [Tipo de Factura] as 'Factura/Tipo',
    Ciudad as 'Cliente/Ciudad',
    [Tipo de Cliente] as 'Cliente/Tipo',
    Genero as 'Cliente/Genero',
    [Linea de Producto] as 'Producto/Linea',
    Producto as 'Producto/Nombre',
    [Precio Unitario] as 'Producto/PrecioUnitario',
    Cantidad as 'Producto/Cantidad',
    Costo as 'Producto/Costo',
    Fecha as 'Venta/Fecha',
    Hora as 'Venta/Hora',
    [Medio de Pago] as 'Venta/MedioDePago',
    Empleado as 'Venta/Empleado',
    Sucursal as 'Venta/Sucursal'
from ventas.VentaCompleta
for xml path('VentaCompleta'), root('Ventas');
end;
go

--Creamos el store procedure para el reporte de la venta mensual 
create or alter procedure ventas.ReporteVentaMensual
	@mes int,
	@anio int
as
begin
	set nocount on;
    --Creamos una tabla temporal para almacenar los resultados
    create table #TotalesPorDia (
        Dia varchar(20),
		DiaNumero int,
        Total decimal(10,2),
		Iva decimal(10,2)
    );
    --Insertamos los totales facturados por cada día de la semana
    insert into #TotalesPorDia (Dia,DiaNumero,Total,Iva)
    select 
        format(v.fecha, 'dddd', 'es-ES'),
		datepart(weekday, v.fecha),
        sum(v.total),
		sum(f.total_iva)
    from ventas.Venta as v inner join ventas.Factura as f on f.id_venta = v.id
    where 
        month(v.fecha) = @mes and year(v.fecha) = @anio
    group by format(v.fecha, 'dddd', 'es-ES'),datepart(weekday, v.fecha);
    --Mostrar los resultados por pantalla
    select Dia as 'Dia', Total as 'Totales/Total', Iva as 'Totales/Iva'
    from #TotalesPorDia
	order by DiaNumero
	for xml path('VentaMensual'), root('Ventas');
    --Eliminamos la tabla temporal
    drop table #TotalesPorDia;
end;
go

--Creamos la vista del reporte trimestral
create or alter view ventas.VentaTrimestral as
select 
    tur.turno as Turno,
	month(v.fecha) as Mes,
	sum(v.total) as 'Total Facturado',
	sum(f.total_iva) as 'Total Facturado con IVA'
from ventas.Factura f
inner join ventas.Venta v on f.id_venta = v.id
left join sucursales.Empleado e on v.legajo_empleado = e.legajo
left join sucursales.Turno tur on tur.id = e.id_turno
group by tur.turno,month(v.fecha)
go

--Creamos el store procedure para el reporte de la venta trimestral
create or alter procedure ventas.ReporteVentaTrimestral
as
begin
	select 
    Turno,
    Mes,
    [Total Facturado] as 'Totales/Total',
    [Total Facturado con IVA] as 'Totales/Iva'
from ventas.VentaTrimestral
for xml path('VentaTrimestral'), root('Ventas');
end;
go

--Creamos el store procedure para el reporte de los productos por fecha por un rango
create or alter procedure ventas.ReporteProductosPorFecha
    @FechaInicio date,
    @FechaFin date
as
begin
    --Sumamos la cantidad de productos vendidos por fecha
    select 
        sum(v.cantidad_de_productos) as ProductosVendidos,
		v.fecha as Fecha
    from ventas.Venta as v 
    where v.fecha between @fechainicio and @fechafin
    group by v.fecha
    order by ProductosVendidos desc
	for xml path('ProductosPorFecha'), root('Ventas');
end;
go

--Creamos el store procedure para los productos por sucursal por un rango
create or alter procedure ventas.ReporteProductosPorSucursal
    @FechaInicio date,
    @FechaFin date
as
begin
--Sumamos la cantidad de productos vendidos por fecha
    select 
        sum(v.cantidad_de_productos) as ProductosVendidos,
		c.nombre as Sucursal
    from ventas.venta as v
	inner join sucursales.Empleado as e on e.legajo = v.legajo_empleado
	inner join sucursales.Sucursal as s on s.id = e.id_sucursal
	inner join clientes.Ciudad as c on c.id = s.id_ciudad
    where v.fecha between @fechainicio and @fechafin
    group by c.nombre
    order by ProductosVendidos desc
	for xml path('ProductosPorSucursal'), root('Ventas');
end;
go

--Creamos el store procedure para el reporte de los productos mas vendidos en un mes por semana
create or alter procedure ventas.ReporteProductosMasVendidos
	@mes int,
	@anio int
as
begin
    set nocount on;
    --Creamos una tabla temporal para almacenar los resultados por semana
    create table #ProductosPorSemana (
        Semana int,
        Producto varchar(100),
        TotalVendido int,
        Ranking int
    );
	--Declaramos la primera semana del mes para calcular semanas del mes
    declare @primeraSemana int = datepart(week, datefromparts(@anio, @mes, 1));

	--Insertamos los datos en la tabla temporal
    insert into #ProductosPorSemana (Semana, Producto, TotalVendido, Ranking)
    select 
        datepart(week, v.fecha) - @primeraSemana + 1,
        p.nombre,
        sum(dv.cantidad),
        row_number() over (partition by datepart(week, v.fecha)- @primeraSemana + 1 order by sum(dv.cantidad) desc) as Ranking
    from ventas.Venta v
    inner join ventas.DetalleDeVenta dv on v.id = dv.id_venta
    inner join productos.Producto p on dv.id_producto = p.id
    where month(v.fecha) = @mes and year(v.fecha) = @anio
    group by datepart(week, v.fecha)- @primeraSemana + 1, p.nombre;
	--Seleccionar los resultados filtrando solo los 5 productos más vendidos por semana y generamos el xml
    select 
        Semana,
        Producto as 'Producto/Nombre',
        TotalVendido as 'Producto/Cantidad'
    from #ProductosPorSemana
    where Ranking <= 5
    order by Semana, Ranking
	for xml path('ProductosMasVendidos'), root('Ventas');
    --Eliminamos la tabla temporal
    drop table #ProductosPorSemana;
end;
go

--Creamos el store procedure para el reporte de los productos menos vendidos en un mes
create or alter procedure ventas.ReporteProductosMenosVendidos
    @mes int,
    @anio int
as
begin
    set nocount on;
    --Creamos una tabla temporal para almacenar los productos con su ranking
    create table #ProductosMenosVendidos (
        Producto nvarchar(100),
        TotalVendido int,
        Ranking int
    );
    --Insertamos los datos en la tabla temporal con ranking
    insert into #ProductosMenosVendidos (Producto, TotalVendido, Ranking)
    select 
        p.nombre,
        sum(dv.cantidad),
        row_number() over (order by sum(dv.cantidad)) as Ranking
    from productos.Producto p
    left join ventas.DetalleDeVenta dv on p.id = dv.id_producto
    left join ventas.Venta v on dv.id_venta = v.id
    where month(v.fecha) = @mes and year(v.fecha) = @anio
    group by p.nombre;
	--Seleccionamos los 5 productos menos vendidos y generamos el xml
    select 
        Producto as 'Producto/Nombre',
        TotalVendido as 'Producto/Cantidad'
    from #ProductosMenosVendidos
	where Ranking <=5
    order by Ranking
	for xml path('ProductosMenosVendidos'), root('Ventas');
    --Eliminamos la tabla temporal
    drop table #ProductosMenosVendidos;
end;
go

--Creamos el store procedure para el reporte del total de ventas en una fecha para una sucursal
create or alter procedure ventas.ReporteTotalVentas
    @fecha date,
    @sucursal int
as
begin
    set nocount on;
	--Mostramos el total acumulado de las ventas para la fecha y sucursal especificadas
    select
		(
		select
			count(*) as CantidadDeVentas,
			sum(v.Costo) as TotalAcumulado
		from ventas.VentaCompleta as v
		inner join clientes.Ciudad as c on c.nombre = v.Sucursal
		where Fecha = @fecha and c.id = @sucursal
		for xml path('Resumen'),type
		),
		--Obtenemos el detalle de las ventas para la fecha y la sucursal específicas
		(
		select 
		[ID Factura] as 'Factura/ID',
		[Tipo de Factura] as 'Factura/Tipo',
		Ciudad as 'Cliente/Ciudad',
		[Tipo de Cliente] as 'Cliente/Tipo',
		Genero as 'Cliente/Genero',
		[Linea de Producto] as 'Producto/Linea',
		Producto as 'Producto/Nombre',
		[Precio Unitario] as 'Producto/PrecioUnitario',
		Cantidad as 'Producto/Cantidad',
		Costo as 'Producto/Costo',
		Fecha as 'Venta/Fecha',
		Hora as 'Venta/Hora',
		[Medio de Pago] as 'Venta/MedioDePago',
		Empleado as 'Venta/Empleado',
		Sucursal as 'Venta/Sucursal'
		from ventas.VentaCompleta as v
		inner join clientes.Ciudad as c on c.nombre = v.Sucursal
		where Fecha = @fecha and c.id = @sucursal
		for xml path('Detalle'), type
		)
		for xml path ('Ventas');
end;
go
