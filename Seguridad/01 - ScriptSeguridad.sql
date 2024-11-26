use g05com2900
go

------------------------------------------ ROLE SUPERVISOR --------------------------------------------------------------------------

create login SupervisorLogin with password = 'supervisor2024';
go
create user Supervisor for login SupervisorLogin;
go

create login CajeroLogin with password = 'cajero2024';
go
create user Cajero for login CajeroLogin;
go

create role SupervisorRole;
go

grant insert on ventas.NotaDeCredito to SupervisorRole;
go

alter role SupervisorRole add member [Supervisor];
go

execute as user = 'Supervisor';
revert;

execute as user = 'Cajero';
revert;

insert into ventas.notadecredito (id_factura, motivo, monto, fecha)
values (1, 'motivo de prueba', 255, getdate());

insert into ventas.notadecredito (id_factura, motivo, monto, fecha)
values (1, 'otro motivo de prueba', 255, getdate());

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


open symmetric key EmployeeKey decryption by password = 'ClaveSegura123!';
update sucursales.Empleado
set dni = Convert(nvarchar, DecryptByKey(dni)),
       cuil = Convert(nvarchar, DecryptByKey(cuil)),
       email_personal = Convert(nvarchar, DecryptByKey(email_personal)),
       email_empresa = Convert(nvarchar, DecryptByKey(email_empresa));
from sucursales.Empleado;
close symmetric key EmployeeKey;
go

