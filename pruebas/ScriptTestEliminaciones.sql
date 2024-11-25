--Nos posicionamos en la base de datos
use g05com2900
go

--Creamos los test para probar las eliminaciones

--Test para la tabla tipo de cliente
exec clientes.EliminarTipoDeCliente 2
--Ejecuta correctamente y elimina el tipo de cliente
exec clientes.EliminarTipoDeCliente 2
--No elimina y muestra un mensaje ya que no existe el tipo de cliente en la base de datos

--Test para la tabla de ciudad
exec clientes.EliminarCiudad 2
--Ejecuta correctamente y elimina la ciudad
exec clientes.EliminarCiudad 2
--No elimina y muestra un mensaje ya que no existe la ciudad en la base de datos

--Test para la tabla de generos
exec clientes.EliminarGenero 2
--Ejecuta correctamente y elimina el genero
exec clientes.EliminarGenero 2
--No elimina y muestra un mensaje ya que no existe el genero en la base de datos

--Test para la tabla clientes
exec clientes.EliminarCliente 3
--Ejecuta correctamente y marca como eliminado el cliente
exec clientes.EliminarCliente 3
--No elimina y muestra un mensaje ya que el cliente no existe o ya esta marcado como eliminado

--Test para la tabla de sucursales
exec sucursales.EliminarSucursal 2
--Ejecuta correctamente y marca como eliminada la sucursal
exec sucursales.EliminarSucursal 2
--No elimina y muestra un mensaje ya que la sucursal no existe o ya esta marcada como eliminada

--Test para la tabla de tipo de cargo
exec sucursales.EliminarTipoDeCargo 2
--Ejecuta correctamente y elimina el tipo de cargo
exec sucursales.EliminarTipoDeCargo 2
--No elimina y muestra un mensaje ya que el tipo de cargo no existe en la base de datos

--Test para la tabla de turnos
exec sucursales.EliminarTurno 2
--Ejecuta correctamente y elimina el turno
exec sucursales.EliminarTurno 2
--No elimina y muestra un mensaje ya que el turno no existe en la base de datos

--Test para la tabla de empleados
exec sucursales.EliminarEmpleado 25370442
--Ejecuta correctamente y marca como eliminado 
exec sucursales.EliminarEmpleado 25370442
--No elimina y muestra un mensaje ya que el empleado no existe o se marco como eliminado

--Test para la tabla de medios de pago
exec ventas.EliminarMedioDePago 2
--Ejecuta correctamente y elimina los medios de pago
exec ventas.EliminarMedioDePago 2
--No elimina y muestra un mensaje ya que el medio de pago no existe en la base de datos

--Test para la tabla de tipos de factura
exec ventas.EliminarTipoDeFactura 2
--Ejecuta correctamente y elimina el tipo de factura
exec ventas.EliminarTipoDeFactura 2
--No elimina y muestra un mensaje ya que el tipo de factura no existe en la base de datos

--Tests para eliminar una venta completa
exec ventas.EliminarVentaCompleta 4
--Ejecuta correctamente y elimina una venta completa, factura, venta y detalles
exec ventas.EliminarVentaCompleta 4
--No elimina y muestra un mensaje ya que la venta no existe en la base de datos
exec ventas.EliminarVentaCompleta 3
--No elimina y muestra un mensaje ya que la venta esta pagada y no se puede eliminar

--Test para la tabla de pago
exec ventas.EliminarPago 3
--Ejecuta correctamente y elimina el pago
exec ventas.EliminarPago 3
--No elimina y muestra un mensaje ya que el pago no existe en la base de datos

--Test para la tabla de lineas de producto
exec productos.EliminarLineaDeProducto 3
--Ejecuta correctamente y elimina la linea de producto
exec productos.EliminarLineaDeProducto 3
--No elimina y muestra un mensaje ya que la linea de producto no existe

--Test para la tabla de producto
exec productos.EliminarProducto 4
--Ejecuta correctamente y elimina el producto
exec productos.EliminarProducto 4
--No elimina y muestra un mensaje ya que el producto no existe en la base de datos
