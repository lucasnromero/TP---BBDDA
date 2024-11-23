--Nos posicionamos en la base de datos
use g05com2900
go

--Creamos los test para probar las insercciones

--Tests para la tabla de tipo de cliente
exec clientes.InsertarTipoDeCliente 'VIP';
--Ejecuta correctamente e inserta el tipo de cliente en la base de datos.
exec clientes.InsertarTipoDeCliente 'VIP';
--No inserta y devuelve un mensaje ya que el tipo de cliente existe en la base de datos.

--Tests para la tabla de ciudad
exec clientes.InsertarCiudad 'Castelar'
--Ejecuta correctamente e inserta la ciudad en la base de datos
exec clientes.InsertarCiudad 'Castelar'
--No inserta y devuelve un mensaje ya que la ciudad ya existe en la base de datos

--Tests para la tabla de generos
exec clientes.InsertarGenero 'Masculino'
--Ejecuta correctamente e inserta el genero en la base de datos
exec clientes.InsertarGenero 'Masculino'
--No inserta y devuelve un mensaje ya que el genero ya existe en la base de datos

--Tests para la tabla de clientes
exec clientes.InsertarCliente 1,1,1,'Luciano','Romano',43242414,'2001-04-20','Bogado 3158'
--Ejecuta correctamente e inserta el cliente en la base de datos
exec clientes.InsertarCliente 1,1,1,'Patricio','Ramirez',43242414,'2000-12-3','Monteverde 215'
--No inserta y devuelve un mensaje ya que existe un cliente con ese dni en la base de datos
exec clientes.InsertarCliente 1,1,1,'Patricio','Ramirez',42034245,'2000-12-3','Monteverde 215'
--Ahora si inserta correctamente el cliente
exec clientes.InsertarCliente 1,1,1
--Inserta un cliente donde no se especificaron algunos parametros, esto nos sirve para importar los clientes 

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

--Test para la tabla de turnos
exec sucursales.InsertarTurno 'Turno Noche'
--Ejecuta correctamente e inserta el turno en la base de datos
exec sucursales.InsertarTurno 'Turno Noche'
--No inserta y devuelve un mensaje ya que existe el turno en la base de datos

--