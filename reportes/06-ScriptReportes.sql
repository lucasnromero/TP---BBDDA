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

--Creamos el store procedure para la venta mensual 
create or alter procedure ventas.VentaMensual
	@mes int,
	@anio int
as
begin
	set nocount on;
    --Creamos una tabla temporal para almacenar los resultados
    create table #TotalesPorDia (
        Dia varchar(20),
        Total decimal(10,2),
		Iva decimal(10,2)
    );
    --Insertamos los totales facturados por cada día de la semana
    insert into #TotalesPorDia (Dia, Total,Iva)
    select 
        format(v.fecha, 'dddd', 'es-ES'), 
        sum(v.total),
		sum(f.total_iva)
    from ventas.Venta as v inner join ventas.Factura as f on f.id_venta = v.id
    where 
        month(v.fecha) = @mes and year(v.fecha) = @anio
    group by format(v.fecha, 'dddd', 'es-ES');
    --Mostrar los resultados por pantalla
    select Dia,Total as 'Total Facturado',Iva as 'Total Facturado con IVA'
    from #TotalesPorDia;
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

--Creamos el store procedure para los productos por fecha por un rango
create or alter procedure ventas.ProductosPorFecha
    @FechaInicio date,
    @FechaFin date
as
begin
    --Sumamos la cantidad de productos vendidos por fecha
    select 
        sum(v.cantidad_de_productos) as 'Productos Vendidos',
		v.fecha as Fecha
    from ventas.Venta as v 
    where v.fecha between @fechainicio and @fechafin
    group by v.fecha
    order by [Productos Vendidos] desc;
end;
go

--Creamos el store procedure para los productos por sucursal por un rango
create or alter procedure ventas.ProductosPorSucursal
    @FechaInicio date,
    @FechaFin date
as
begin
--Sumamos la cantidad de productos vendidos por fecha
    select 
        sum(v.cantidad_de_productos) as 'Productos Vendidos',
		c.nombre as Sucursal
    from ventas.venta as v
	inner join sucursales.Empleado as e on e.legajo = v.legajo_empleado
	inner join sucursales.Sucursal as s on s.id = e.id_sucursal
	inner join clientes.Ciudad as c on c.id = s.id_ciudad
    where v.fecha between @fechainicio and @fechafin
    group by c.nombre
    order by [Productos Vendidos] desc;
end;
go

--Creamos la vista para los productos mas vendidos en un mes por semana
create or alter view ventas.TopProductosMensualesPorSemana as
with ProductosVendidos as (
    select
        datepart(week, v.fecha) as semana,
        p.nombre as producto,
        sum(dv.cantidad) as cantidad_vendida,
        row_number() over (partition by datepart(week, v.fecha) order by sum(dv.cantidad) desc) as ranking
    from 
        ventas.DetalleDeVenta dv
    inner join 
        productos.Producto p on dv.id_producto = p.id
    inner join 
        ventas.Venta v on dv.id_venta = v.id
    --where 
        --month(v.fecha) = month(getdate()) -- Puedes cambiar esto a un mes específico si lo necesitas
        --and year(v.fecha) = year(getdate()) -- Para asegurarte de que sea del mismo año
    group by 
        datepart(week, v.fecha), p.nombre
)
select 
    semana,
    producto,
    cantidad_vendida
from 
    ProductosVendidos
where 
    ranking <= 5
go

select * from ventas.TopProductosMensualesPorSemana




