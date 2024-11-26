--Este script se encarga de ejecutar los reportes

--Nos posicionamos en la base de datos
use com2900g05
go

--Ejecutamos el store procedure para probar el reporte de ventas completo
exec ventas.ReporteVentaCompleta
go

--Ejecutamos el store procedure para probar el reporte de ventas mensual
exec ventas.ReporteVentaMensual 1,2019
go

--Ejecutamos el store procedure para probar el reporte de ventas trimestral
exec ventas.ReporteVentaTrimestral
go

--Ejecutamos el store procedure para probar el reporte de productos por fecha
exec ventas.ReporteProductosPorFecha '2019-1-1','2019-2-28'
go

--Ejecutamos el store procedure para probar el reporte de productos por sucursal
exec ventas.ReporteProductosPorSucursal '2019-1-1','2019-2-28'
go

--Ejecutamos el store procedure para probar el reporte de productos mas vendidos
exec ventas.ReporteProductosMasVendidos 1,2019
go

--Ejecutamos el store procedure para probar el reporte de productos menos vendidos
exec ventas.ReporteProductosMenosVendidos 1,2019
go

--Ejecutamos el store procedure para probar el reporte del total de ventas por sucursal
exec ventas.ReporteTotalVentas '2019-1-1',4
go

