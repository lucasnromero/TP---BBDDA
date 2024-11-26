--Este script se encarga de crear todo lo relacionado con la seguridad en las tablas de la base de datos

--Nos posicionamos en la base de datos
use com2900g05
go

--Creamos un esquema para la seguridad
create schema seguridad
go

--Creamos el store procedure para la inserccion de una nota de credito
create or alter procedure seguridad.InsertarNotaDeCredito
    @id_factura int,
    @motivo varchar(100),
    @monto decimal(10,2)
as
begin
	--Verificamos que el estado de la factura sea pagada
    if not exists (select 1 from ventas.Factura where id = @id_factura and estado = 'Pagada')
    begin
        print 'No se puede generar la nota de crédito porque la factura no esta pagada.'
        return;
    end
    --Insertamos una nueva nota de crédito en la tabla
    insert into ventas.NotaDeCredito (id_factura, motivo, monto)
    values (@id_factura, @motivo, @monto);
    --Mostramos el ID de la nota de credito insertada
    print 'Nota de credito insertada correctamente con ID: ' + cast(@id_factura as varchar(4));
end;
go

------------------------------------------ ROLE SUPERVISOR --------------------------------------------------------------------------
--Creamos los logins con los usarios
create login SupervisorLogin with password = 'supervisor2024';
go
create user Supervisor for login SupervisorLogin;
go
create login CajeroLogin with password = 'cajero2024';
go
create user Cajero for login CajeroLogin;
go

--Creamos el rol
create role SupervisorRole;
go

--Le damos permisos al rol
grant insert on ventas.NotaDeCredito to SupervisorRole;
go
grant execute on seguridad.InsertarNotaDeCredito to SupervisorRole;
go
grant alter on seguridad.InsertarNotaDeCredito to SupervisorRole;
go

--Añadimos el usuario supervisor al rol de supervisor
alter role SupervisorRole add member [Supervisor];
go
select * from ventas.Factura

--Nos ponemos en el lugar del supervisor
execute as user = 'Supervisor';
go
--Nos deja insertar la nota de credito
exec seguridad.InsertarNotaDeCredito 3,'motivo 3',300;
go
--No nos deja insertar la nota de credito porque la factura no esta pagada
exec seguridad.InsertarNotaDeCredito 4,'motivo 4',400;
go
revert;

--Nos posicionamos como un cajero
execute as user = 'Cajero';
--No nos deja insertar la nota de credito porque no tenemos permisos
exec seguridad.InsertarNotaDeCredito 1,'motivo 1',100;
go
revert;



----------------------------------------- FIN ROLE SUPERVISOR ------------------------------------------------------------------------


------------------------------------------ ENCRIPTACION EMPLEADOS --------------------------------------------------------------------

select * from sucursales.empleado;
go

-- Crear una clave para encriptación
create symmetric key EmployeeKey with algorithm = AES_256 encryption by password = 'ClaveSegura123!';
go

-- Modificar la tabla para almacenar los datos encriptados
alter table sucursales.Empleado alter column email_personal nvarchar(256)
alter table sucursales.Empleado alter column email_empresa nvarchar(256)
alter table sucursales.Empleado alter column dni nvarchar(256)
alter table sucursales.Empleado alter column cuil nvarchar(256)
go


open symmetric key EmployeeKey decryption by password = 'ClaveSegura123!';
update sucursales.Empleado
set dni = EncryptByKey(Key_GUID('EmployeeKey'), dni),
    cuil = EncryptByKey(Key_GUID('EmployeeKey'), cuil),
    email_personal = EncryptByKey(Key_GUID('EmployeeKey'), email_personal),
    email_empresa = EncryptByKey(Key_GUID('EmployeeKey'), email_empresa);
close symmetric key EmployeeKey;
go

select * from sucursales.empleado;
go


open symmetric key EmployeeKey decryption by password = 'ClaveSegura123!';
update sucursales.Empleado
set dni = Convert(nvarchar, DecryptByKey(dni)),
       cuil = Convert(nvarchar, DecryptByKey(cuil)),
       email_personal = Convert(nvarchar, DecryptByKey(email_personal)),
       email_empresa = Convert(nvarchar, DecryptByKey(email_empresa))
from sucursales.Empleado;
close symmetric key EmployeeKey;
go

select * from sucursales.empleado;
go


-- Modificar la tabla para almacenar los datos encriptados
alter table sucursales.Empleado alter column email_personal varchar(75)
alter table sucursales.Empleado alter column email_empresa varchar(75)
alter table sucursales.Empleado alter column dni int
alter table sucursales.Empleado alter column cuil varchar(15)
go

