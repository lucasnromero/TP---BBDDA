--DEPRECADO

--Fecha de entrega: 05/11
--Número de grupo: 05
--Materia: BASES DE DATOS APLICADAS
--Alumnos:

--42414940 Gonzalez Nazarena Araceli nazgonzalez@alumno.unlam.edu.ar

--43780360 Romero Lucas Nicolas lucasnromero@alumno.unlam.edu.ar 

--43242414 Romano Luciano Javier lromano@alumno.unlam.edu.ar 

--42627797 Burgos Santiago Jesús santburgos@alumno.unlam.edu.ar

--Trabajo práctico Integrador

--Comience usando master y eliminando la base de datos

use master
go

--Eliminar la base de datos si esta creada, si no comente la linea de drop    
drop database g05com2900
go

--Apartir de aqui comienza el script para poder crear la base de datos y todas sus tablas

--Creamos la base de datos
create database g05com2900
go

--Nos posicionamos en la base datos
use g05com2900
go

--Creamos los esquemas para incluir las tablas segun categorias

--Craemos el esquema para las ventas
create schema ventas
go

--Creamos el esquema para los productos
create schema productos
go

--Creamos el esquema para las sucursales
create schema sucursales
go

--Craemos el esquema para los clientes
create schema clientes
go
