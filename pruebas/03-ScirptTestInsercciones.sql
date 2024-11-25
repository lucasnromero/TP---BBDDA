--Nos posicionamos en la base de datos
use g05com2900
go

--Creamos los test para probar las insercciones

--Tests para la tabla de tipo de cliente
exec clientes.InsertarTipoDeCliente 'VIP';
--Ejecuta correctamente e inserta el tipo de cliente en la base de datos.
exec clientes.InsertarTipoDeCliente 'VIP';
--No inserta y devuelve un mensaje ya que el tipo de cliente existe en la base de datos.
exec clientes.InsertarTipoDeCliente 'Generico';
--Ejecuta correctamente e inserta el tipo de cliente en la base de datos.

--Tests para la tabla de ciudad
exec clientes.InsertarCiudad 'Castelar'
--Ejecuta correctamente e inserta la ciudad en la base de datos
exec clientes.InsertarCiudad 'Castelar'
--No inserta y devuelve un mensaje ya que la ciudad ya existe en la base de datos
exec clientes.InsertarCiudad 'Haedo'
--Ejecuta correctamente e inserta la ciudad en la base de datos

--Tests para la tabla de generos
exec clientes.InsertarGenero 'Masculino'
--Ejecuta correctamente e inserta el genero en la base de datos
exec clientes.InsertarGenero 'Masculino'
--No inserta y devuelve un mensaje ya que el genero ya existe en la base de datos
exec clientes.InsertarGenero 'Femenino'
--Ejecuta correctamente e inserta el genero en la base de datos

--Tests para la tabla de clientes
exec clientes.InsertarCliente 1,1,1,'Luciano','Romano',43242414,'2001-04-20','Bogado 3158'
--Ejecuta correctamente e inserta el cliente en la base de datos
exec clientes.InsertarCliente 1,1,1,'Patricio','Ramirez',43242414,'2000-12-3','Monteverde 215'
--No inserta y devuelve un mensaje ya que existe un cliente con ese dni en la base de datos
exec clientes.InsertarCliente 1,1,1,'Patricio','Ramirez',42034245,'2000-12-3','Monteverde 215'
--Ahora si inserta correctamente el cliente
exec clientes.InsertarCliente 1,1,1
--Inserta un cliente donde no se especificaron algunos parametros, esto nos sirve para importar los clientes 
exec clientes.InsertarCliente 2,2,2,'Lucas','Alonso',42885790,'2000-10-05','Sta Maria de Oro 3057'
--Ejecuta correctamente e inserta el cliente en la base de datos

--Test para la tabla de sucursales
exec sucursales.InsertarSucursal 'Moron','Sarmiento 4321','Abierto 24 hs','1122334455'
--Ejecuta correctamente e inserta la sucursal en la base de datos
exec sucursales.InsertarSucursal 'Moron','Sarmiento 4321','Por la tarde','1544894940'
--No inserta y devuelve un mensaje ya que existe una sucursal con esa direccion en esa ciudad
exec sucursales.InsertarSucursal 'Hurlingham','Vergara 3020','De 7 a 13 y de 15 a 19','0800-333-111'
--Ejecuta correctamente e inserta la sucursal en la base de datos

--Test para la tabla de tipos de cargo
exec sucursales.InsertarTipoDeCargo 'Gerente'
--Ejecuta correctamente e inserta el tipo de cargo en la base de datos
exec sucursales.InsertarTipoDeCargo 'Gerente'
--No inserta y devuelve un mensaje ya que existe el tipo de cargo en la base de datos
exec sucursales.InsertarTipoDeCargo 'Repositor'
--Ejecuta correctamente e inserta el tipo de cargo en la base de datos

--Test para la tabla de turnos
exec sucursales.InsertarTurno 'Turno Noche'
--Ejecuta correctamente e inserta el turno en la base de datos
exec sucursales.InsertarTurno 'Turno Noche'
--No inserta y devuelve un mensaje ya que existe el turno en la base de datos
exec sucursales.InsertarTurno 'Turno Vespertino'
--Ejecuta correctamente e inserta el turno en la base de datos

--Test para la tabla de empleados
exec sucursales.InsertarEmpleado 25370440,1,'Lucas','Romero',43780360,'Calle Falsa 123','lromero@personal.com','lromero@empresa.com',1,1,1
--Ejecuta correctamente e inserta el empleado en la base de datos
exec sucursales.InsertarEmpleado 25370440,1,'Luciano','Romano',43242414,'Siempreviva 123','lromano@personal.com','lromano@empresa.com',1,1,1
--No inserta y devuelve un mensaje ya que existe el empleado en la base de datos
exec sucursales.InsertarEmpleado 25370441,1,'Luciano','Romano',43242414,'Siempreviva 123','lromano@personal.com','lromano@empresa.com',1,1,1
--Ejecuta correctamente e inserta el empleado en la base de datos
exec sucursales.InsertarEmpleado 25370442,2,'Lucas','Alonso',42885790,'Montes de oca 123','lalonso@personal.com','lalonso@empresa.com',2,2,2
--Ejecuta correctamente e inserta el empleado en la base de datos

--Test para la tabla de medios de pago
exec ventas.InsertarMedioDePago 'Efectivo'
--Ejecuta correctamente e inserta el medio de pago en la base de datos
exec ventas.InsertarMedioDePago 'Efectivo'
--No inserta y devuelve un mensaje ya que existe el medio de pago en la base de datos
exec ventas.InsertarMedioDePago 'QR'
--Ejecuta correctamente e inserta el medio de pago en la base de datos

--Test para la tabla de tipo de factura
exec ventas.InsertarTipoDeFactura 'F'
--Ejecuta correctamente e inserta el tipo de factura en la base de datos
exec ventas.InsertarTipoDeFactura 'F'
--No inserta y devuelve un mensaje ya que existe el tipo de factura en la base de datos
exec ventas.InsertarTipoDeFactura 'C'
--Ejecuta correctamente e inserta el tipo de factura en la base de datos

--Test para la tabla de linea de producto
exec productos.InsertarLineaDeProducto 'Computadoras','Notebook'
--Ejecuta correctamente e inserta la linea de producto en la base de datos
exec productos.InsertarLineaDeProducto 'Computadoras','Notebook'
--No inserta y devuelve un mensaje ya que existe la linea de producto en la base de datos
exec productos.InsertarLineaDeProducto 'Computadoras','Procesador'
--Ejecuta correctamente e inserta la linea de producto en la base de datos
exec productos.InsertarLineaDeProducto 'Heladeras','Heladera A+'
--Ejecuta correctamente e inserta la linea de producto en la base de datos
exec productos.InsertarLineaDeProducto 'Ventiladores','Industrial'
--Ejecuta correctamente e inserta la linea de producto en la base de datos

--Test para la tabla de productos
exec productos.InsertarProducto 1,'Lenovo s120',840234.24
--Ejecuta correctamente e inserta el producto en la base de datos con datos por defecto
exec productos.InsertarProducto 2,'Intel I7',340500
--Ejecuta correctamente e inserta el producto en la base de datos con datos por defecto
exec productos.InsertarProducto 3,'NEBA 360L',550000,1527,'litros','2024-11-16'
--Ejecuta correctamente e inserta el producto en la base de datos con datos que vienen de lista
exec productos.InsertarProducto 4,'Axel M3',40299.99
--Ejecuta correctamente e inserta el producto en la base de datos con datos por defecto

--Tests para la venta completa, incluye venta, detalle de venta y factura
declare @productos ventas.venta_producto_type
insert into @productos
values (2,1),(3,1);
exec ventas.InsertarVentaCompleta 1,25370440,1,1,@productos
delete from @productos
--Ejecuta correctamente e inserta una venta de 2 productos en la base de datos
insert into @productos
values (2,3),(3,4),(1,2);
exec ventas.InsertarVentaCompleta 4,25370440,1,1,@productos,'3214-124-12'
delete from @productos
--Ejecuta correctamente e inserta una venta de varios productos con codigo de factura en la base de datos
insert into @productos
values (2,1);
exec ventas.InsertarVentaCompleta 2,25370441,1,1,@productos,'11-14-35'
delete from @productos
--Ejecuta correctamente e inserta una venta de un producto en la base de datos
insert into @productos
values (4,4),(3,2);
exec ventas.InsertarVentaCompleta 3,25370440,2,2,@productos
delete from @productos
--Ejecuta correctamente e inserta una venta de 2 productos en la base de datos

--Tests para la tabla de pagos
exec ventas.InsertarPago 1,'Pago 1',1
--Ejecuta correctamtene e inserta un pago en la base de datos
exec ventas.InsertarPago 1,'Pago 2',1
--No inserta y devuelve un mensaje debido a que ya se realizo el pago a esa factura en la base de datos
exec ventas.InsertarPago 2,'Pago 2',1
--Ejecuta correctamtene e inserta un pago en la base de datos
exec ventas.InsertarPago 3,'Pago 3',2
--Ejecuta correctamtene e inserta un pago en la base de datos
