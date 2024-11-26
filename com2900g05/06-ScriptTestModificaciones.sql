--Este script se encarga de ejecutar los store procedures de las modificaciones
--Este script esta pensado para ejecutar antes de las importaciones de los datos

--Nos posicionamos en la base de datos
use com2900g05
go

--Creamos los test para probar las modificaciones

--Test para la tabla TipoDeCliente
exec clientes.ActualizarTipoDeCliente 1,'Cliente Premium';
--Actualiza correctamente el tipo de cliente en la base de datos
exec clientes.ActualizarTipoDeCliente 1,'Cliente Premium';
--No actualiza y muestra un mensaje ya que el tipo de cliente existe en la base de dato

--Test para la tabla Ciudad
exec clientes.ActualizarCiudad 1,'Córdoba';
--Actualiza correcamente la ciudad en la base de datos
exec clientes.ActualizarCiudad 1,'Córdoba';
--No actualiza y muestra un mensaje ya que la ciudad existe en la base de datos

--Test para la tabla Género
exec clientes.ActualizarGenero 1,'No Binario';
--Actualiza correctamente el genero en la base de datos
exec clientes.ActualizarGenero 1,'No Binario';
--No actualiza y muestra un mensaje ya que el genero existe en la base de datos

--Test para la tabla Cliente
exec clientes.ActualizarCliente 1,2,1,1,'Carlos','Perez',45678901,'1990-05-15','Calle Siempreviva 742';
--Actualiza correctamente el cliente en la base de datos
exec clientes.ActualizarCliente 2,2,1,1,'Matias','Garin',45678901,'1995-07-20','Calle Mala 732';
--No actualiza y muestra un mensaje ya que existe un cliente con ese dni en la base de datos

--Test para la tabla Sucursal
exec sucursales.ActualizarSucursal 1,2,'Av. Principal 123','9:00-18:00','351-1234567';
--Actualiza correctamente la sucursal en la base de datos
exec sucursales.ActualizarSucursal 2,2,'Av. Principal 123','9:00-18:00','351-1234567';
--No actualiza y muestra un mensaje ya que existe una sucursal con esa direccion en esa ciudad en la base de datos

--Test para la tabla TipoDeCargo
exec sucursales.ActualizarTipoDeCargo 1,'Gerente General';
--Actualiza correctamene el tipo de cargo en la base de datos
exec sucursales.ActualizarTipoDeCargo 2,'Gerente General';
--No actualiza y muetra un mensaje ya que existe el tipo de cargo en la base de datos

--Test para de la tabla Turno
exec sucursales.ActualizarTurno 1,'Tarde';
--Actualiza correctemente el turno en la base de datos
exec sucursales.ActualizarTurno 2,'Tarde';
--No actualiza y muestra un mensaje ya que existe el turno en la base de datos

--Test para la tabla Empleado
exec sucursales.ActualizarEmpleado 25370440,1,1,2,'Laura','Gomez',34789012,'Calle de los Sueños 10','laura.gomez@gmail.com','lgomez@empresa.com';
--Actualiza correctamente el empleado en la base de datos
exec sucursales.ActualizarEmpleado 25370441,1,1,2,'Jorge','Rosito',34789012,'Calle Grovee','jorge.rosito@gmail.com','jrosito@empresa.com';
--No actualiza y muestra un mensaje ya que existe un empleado con ese dni en la base de datos

--Test para la tabla MedioDePago
exec ventas.ActualizarMedioDePago 1,'Transferencia Bancaria';
--Actualiza correctamene el medio de pago en la base de datos
exec ventas.ActualizarMedioDePago 2,'Transferencia Bancaria';
--No actualiza y muestra un mensaje ya que existe el medio de pago en la base de datos

--Test para la tabla TipoDeFactura
exec ventas.ActualizarTipoDeFactura 1,'Factura C';
--Actualiza correctamene el tipo de factura en la base de datos
exec ventas.ActualizarTipoDeFactura 2,'Factura C';
--No actualiza y muestra un mensaje ya que existe el tipo de factura en la base de datos

--Test para la tabla LineaDeProducto
exec productos.ActualizarLineaDeProducto 1,'Electronica','Consumo';
--Actualiza correctamente la linea de producto en la base de datos
exec productos.ActualizarLineaDeProducto 2,'Electronica','Consumo';
--No actualiza y muestra un mensaje ya que existe la linea de producto en la base de datos

--Test para la tabla Producto
exec productos.ActualizarProducto 1, 2,'Televisor 4K',120000.00,100000.00,'Unidad','2024-11-10'
--Actualiza correctamene el producto en la base de datos
exec productos.ActualizarProducto 3, 2,'Televisor 4K',120000.00,100000.00,'Unidad','2024-11-10'
--No actualiza y muestra un mensaje ya que existe el producto en la base de dato