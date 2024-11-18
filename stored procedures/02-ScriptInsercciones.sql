--Para ejecutar este script primero debio haber ejecutado el script de CreacionClientes

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los store procedures de inserccion para el esquema de clientes, si existen los actualizamos

--Creamos el store procedure par insertar los tipos de clientes
create or alter procedure clientes.InsertarTipoDeCliente
    @tipo varchar(15)
as
begin
    --Corroboramos que el tipo de cliente que queremos insertar no exista
    if exists(select 1 from clientes.TipoDeCliente where tipo = @tipo)
    begin
        print 'Ya existe ese tipo de Cliente.'
        return;
    end
    --Insertamos el tipo de cliente
    insert into clientes.TipoDeCliente(tipo)
    values(@tipo);
    --Mostramos el ID del tipo de cliente insertado
    declare @NuevoID int = scope_identity();
    print 'Tipo de Cliente insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Cremos el store procedure para insertar las cuidades
create or alter procedure clientes.InsertarCiudad
    @nombre varchar(60)
as
begin
    --Corroboramos que la ciudad que queremos insertar no exista
    if exists(select 1 from clientes.Ciudad where nombre = @nombre)
    begin
        print 'Ya existe esa Ciudad.'
        return;
    end
    --Insertamos la ciudad
    insert into clientes.Ciudad(nombre)
    values(@nombre);
    --Mostramos el ID de la ciudad insertada
    declare @NuevoID int = scope_identity();
    print 'Ciudad insertada correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar los generos
create or alter procedure clientes.InsertarGenero
    @tipo varchar(30)
as
begin
    --Corroboramos que el genero que queremos insertar no exista
    if exists(select 1 from clientes.Genero where tipo = @tipo)
    begin
        print 'Ya existe ese Genero.'
        return;
    end
    --Insertamos el genero
    insert into clientes.Genero(tipo)
    values(@tipo);    
    --Mostamos el ID del genero insertado
    declare @NuevoID int = scope_identity();
    print 'Genero insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos los store procedure para insertar los clientes
create or alter procedure clientes.InsertarCliente
    @id_tipo_de_cliente int,
    @id_ciudad int,
    @id_genero int,
    @nombre varchar(50),
    @apellido varchar(50),
    @dni int,
    @fecha_nacimiento date,
    @direccion varchar(60)
as
begin
    --Corroboramos que el tipo que queremos insertar no exista
    if exists(select 1 from clientes.Cliente where dni = @dni)
    begin
        print 'Ya existe un Cliente con ese DNI.'
        return;
    end

    --Insertamos el cliente
    insert into clientes.Cliente(
        id_tipo_de_cliente, id_ciudad, id_genero, nombre, apellido, dni, fecha_nacimiento, direccion
    )
    values(
        @id_tipo_de_cliente, @id_ciudad, @id_genero, @nombre, @apellido, @dni, @fecha_nacimiento, @direccion
    );
    --Mostamos el ID del clietne insertado
    declare @NuevoID int = scope_identity();
    print 'Cliente insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos los store procedures de inserccion para el esquema de sucursales

--Creamos el store procedure para insertar sucursales
create or alter procedure sucursales.InsertarSucursal
    @ciudad varchar(60),
    @direccion varchar(100),
	@horario varchar(100),
	@telefono varchar(20)
as
begin
    --Corroboramos si ya existe una sucursal con la misma ciudad y localidad
    if exists (select 1 from sucursales.Sucursal where direccion = @direccion)
    begin
        print 'Ya existe una sucursal con esa direccion.'
        return;
    end
    --Insertamos la nueva sucursal
    insert into sucursales.Sucursal (ciudad, direccion, horario, telefono)
    values (@ciudad, @direccion, @horario, @telefono);
    --Mostramos por pantalla el id de la nueva sucursal
    declare @NuevoID int = scope_identity();
    print 'Sucursal insertada correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar tipos de cargo
create or alter procedure sucursales.InsertarTipoDeCargo
	@tipo varchar(40)
as
begin
	--Corroboramos si ya existe el tipo de cargo
	if exists (select 1 from sucursales.TipoDeCargo where tipo = @tipo)
	begin
		print 'Ya existe un tipo de cargo con esa descripcion'
		return;
	end
	--Insertamos el nuevo tipo de cargo
	insert into sucursales.TipoDeCargo (tipo)
	values (@tipo);
	--Mostramos por pantalla el id del nuevo tipo de cargo
	declare @NuevoID int = scope_identity();
	print 'Tipo de cargo insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos el store procedure para insertar los turnos
create or alter procedure sucursales.InsertarTurno
	@turno varchar(30)
as
begin
	--Corroboramos si ya existe el turno
	if exists (select 1 from sucursales.TipoDeCargo where tipo = @tipo)
	begin
		print 'Ya existe un turno con esa descripcion'
		return;
	end
	--Insertamos el nuevo turno
	insert into sucursales.Turno (turno)
	values (@turno);
	--Mostramos por pantalla el id del nuevo turno
	declare @NuevoID int = scope_identity();
	print 'Turno insertado correctamente con ID: ' + cast(@NuevoID as varchar(4));
end;
go

--Creamos la funcion para calcular los cuils de los empleados
create or alter function sucursales.CalcularCUIL (
    @dni int,
    @id_genero int
)
returns varchar(15)
as
begin
    declare @prefijo char(2)
    declare @suma int
    declare @resto int
    declare @verificador int
    declare @cuil varchar(15)

    -- asignar prefijo según el género
    set @prefijo = case @id_genero
        when 1 then '20' -- masculino
        when 2 then '27' -- femenino
        else '23'        -- generico
    end

    -- calcular el dígito verificador usando módulo 11
    set @suma = 
          (substring(@prefijo, 1, 1) * 5) +
          (substring(@prefijo, 2, 1) * 4) +
          (substring(cast(@dni as varchar(8)), 1, 1) * 3) +
          (substring(cast(@dni as varchar(8)), 2, 1) * 2) +
          (substring(cast(@dni as varchar(8)), 3, 1) * 7) +
          (substring(cast(@dni as varchar(8)), 4, 1) * 6) +
          (substring(cast(@dni as varchar(8)), 5, 1) * 5) +
          (substring(cast(@dni as varchar(8)), 6, 1) * 4) +
          (substring(cast(@dni as varchar(8)), 7, 1) * 3) +
          (substring(cast(@dni as varchar(8)), 8, 1) * 2)
	--Substring toma el primer parametro que es una cadena, por esto es que el dni
	--lo tenemos que convertir a cadena con un cast, luego con el segundo parametro es 
	--el la posicion de inicio de la cadena y el tercer parametro le dice cuantos caracteres
	--va a extraer de la cadena. Por ultimo se multiplica por un numero que corresponde a un
	--algoritmo que se utilza para calcular el cuil

	--Usamos el resto para definir el verificador del cuil
    set @resto = @suma % 11

    if @resto = 0 --Si el resto es 0 el verificador es 0
        set @verificador = 0
    else if @resto = 1 --Si el resto es 1 el prefijo cambia a 23 y los verificadores cambiar a 9 para los masculinos y 4 para femeninos o genericos
        begin
            set @prefijo = '23'
            set @verificador = case @id_genero when 1 then 9 else 4 end
        end
    else --Si el resto es distinto el verificador se calculo con 11 menos el resto
        set @verificador = 11 - @resto

    --Formamos el cuil con el formato prefijo-dni-verificador
    set @cuil = @prefijo + '-' + cast(@dni as varchar(8)) + '-' + cast(@verificador as varchar(1))

    return @cuil
end;
go


--Creamos el store procedure para insertar empleados
create or alter procedure  sucursales.InsertarEmpleado
    @legajo int
	@id_genero int,
    @nombre varchar(50),
    @apellido varchar(50),
    @dni int
    @direccion varchar(100),
	@email_personal varchar(75),
	@email_empresa varchar(75),
	@id_cargo int,
	@id_sucursal int,
	@id_turno int,
as
begin
    --Verificamos si existe el empleado que intentamos ingresar, lo validamos atraves del legajo
    if exists (select 1 from sucursales.Empleado where legajo = @legajo)
    begin
        print 'Ya existe un empleado con ese legajo.'
        return;
    end
	--Declaramos el cuil
	declare @cuil varchar(15)
    --Calculamos el cuil
    set @cuil = sucursales.CalcularCUIL(@dni, @id_genero)
    --Insertamos el nuevo empleado
    insert into sucursales.Empleado (legajo, id_genero, nombre, apellido, dni, direccion
		email_personal, email_empresa, cuil, id_cargo, id_sucursal, id_turno)
    values (@legajo, @id_genero, @nombre, @apellido, @dni, @direccion, @email_personal, @email_empresa
	@cuil, @id_cargo, @id_sucursal, @id_turno);
    --Mostramos por pantalla el id del nuevo empleado
    declare @NuevoID int = scope_identity();
    print 'Empleado insertado correctamente con ID:' + cast(@NuevoID as varchar(4));
end;
go

