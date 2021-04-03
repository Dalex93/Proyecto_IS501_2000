CREATE DATABASE HotelEmperador;
GO
Use HotelEmperador;
GO

CREATE TABLE Paises (
IdPais INTEGER PRIMARY KEY,
Nombre VARCHAR(100) NOT NULL,
Nacionalidad VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Departamentos (
IdDepartamento INTEGER PRIMARY KEY,
PaisId INTEGER REFERENCES Paises(IdPais),
Nombre VARCHAR(100) NOT NULL
);
GO


CREATE TABLE Ciudades (
IdCiudad INTEGER PRIMARY KEY,
PaisId INTEGER REFERENCES Paises(IdPais),
DepartamentoId INTEGER REFERENCES Departamentos(IdDepartamento),
Nombre VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Colonias (
IdColonia INTEGER PRIMARY KEY,
PaisId INTEGER REFERENCES Paises(IdPais),
DepartamentoId INTEGER REFERENCES Departamentos(IdDepartamento),
CiudadId INTEGER REFERENCES Ciudades(IdCiudad),
Nombre VARCHAR(255) NOT NULL
);
GO


CREATE TABLE Direcciones (
IdDireccion INTEGER PRIMARY KEY,
ColoniaId INTEGER REFERENCES Colonias(IdColonia),
DepartamentoId INTEGER REFERENCES Departamentos(IdDepartamento),
CiudadId INTEGER REFERENCES Ciudades(IdCiudad),
PaisId INTEGER REFERENCES Paises(IdPais),
Referencia VARCHAR(100) NOT NULL
);
GO


----------------------------------------------------------------------------------

CREATE TABLE TipoProducto (
IdTipoProducto INTEGER PRIMARY KEY,
NombreTipo VARCHAR(100) NOT NULL, 
);
GO
ALTER TABLE TipoProducto ADD CONSTRAINT Tipos CHECK (
IdTipoProducto=1 AND NombreTipo = 'Entrada' OR
IdTipoProducto=2 AND NombreTipo = 'Plato fuerte' OR
IdTipoProducto=3 AND NombreTipo = 'Postre' OR
IdTipoProducto=4 AND NombreTipo = 'Bebida' 
);
GO
CREATE TABLE ProductoRestaurante(
IdProducto INTEGER PRIMARY KEY NOT NULL,
Nombre VARCHAR (100) NOT NULL,
Ingredientes VARCHAR (500) NOT NULL, 
Precio DECIMAL (13,2) NOT NULL,
CHECK (Precio>=0),
Tipo INTEGER FOREIGN KEY REFERENCES TipoProducto (IdTipoProducto) 
);
GO
CREATE TABLE Hotel(
IdHotel INTEGER PRIMARY KEY NOT NULL,
Nombre VARCHAR(50) NOT NULL,
Telefono VARCHAR(20) NOT NULL,
CorreoElectronico VARCHAR(250) NOT NULL,		
Direccion INTEGER REFERENCES Direcciones(IdDireccion),		
);
GO 


CREATE TABLE Restaurante (
IdRestaurante INTEGER NOT NULL,
Producto INTEGER FOREIGN KEY REFERENCES ProductoRestaurante (IdProducto),
PRIMARY KEY (IdRestaurante, Producto),
HotelId INTEGER REFERENCES Hotel(IdHotel)
);
GO


-------------------------------------------------------------------------------------


CREATE TABLE CargoEmpleado(
IdCargo INTEGER PRIMARY KEY NOT NULL,
NombreCargo VARCHAR(100) NOT NULL,
Descripcion VARCHAR(300) NOT NULL,
Sueldo DECIMAL(13,2) NOT NULL
);
GO


CREATE TABLE Empleado(
IdEmpleado INTEGER PRIMARY KEY NOT NULL,
PrimerNombre VARCHAR(50) NOT NULL,
SegundoNombre VARCHAR(50),
PrimerApellido VARCHAR(50) NOT NULL,
SegundoApellido VARCHAR(50),
CorreoElectronico VARCHAR(250) NOT NULL,
Telefono VARCHAR(50) NOT NULL,
Cargo INTEGER REFERENCES CargoEmpleado(IdCargo),
Direccion INTEGER REFERENCES Direcciones(IdDireccion)
);
GO
ALTER TABLE Empleado Add CONSTRAINT CargoCk CHECK(
		Cargo=1001 OR
		Cargo=2001 OR
		Cargo=3001 OR
		Cargo=4001 OR
		Cargo=4002 OR
		Cargo=4003
);
GO


CREATE TABLE EmpleadoHoteles(
IdPuesto INTEGER PRIMARY KEY,
EmpleadoId INTEGER REFERENCES Empleado(IdEmpleado),
HotelId INTEGER REFERENCES Hotel(IdHotel)
);
GO


------------------------------------------------------------------------------

CREATE TABLE TipoHabitacion(
IdTipo INTEGER PRIMARY KEY,
NombreTipo VARCHAR(100)NOT NULL,
NumeroCamas INTEGER NOT NULL,
Descripcion VARCHAR(100) NOT NULL,
Precio DECIMAL(13,2) NOT NULL
);
GO

ALTER TABLE TipoHabitacion ADD CONSTRAINT CK_NombreTipo CHECK(
IdTipo=1 AND NombreTipo='Individual' OR
IdTipo=2 AND NombreTipo='doble' OR
IdTipo=3 AND NombreTipo='doble-doble' OR
IdTipo=4 AND NombreTipo='triple' OR
IdTipo=5 AND NombreTipo='quad' OR
IdTipo=6 AND NombreTipo='king' OR
IdTipo=7 AND NombreTipo='queen' OR
IdTipo=8 AND NombreTipo='suite presidencial');
GO


CREATE TABLE Habitacion(
NumeroHabitacion INTEGER PRIMARY KEY,
NumeroTelefono VARCHAR(50) NOT NULL,
Disponibilidad BIT NOT NULL,--No Disponible=1, Disponible=0-- 
HotelId INTEGER REFERENCES Hotel(IdHotel),
TipoId INTEGER REFERENCES TipoHabitacion(IdTipo) 
); 
GO


CREATE TABLE Huesped(
IdHuesped INTEGER PRIMARY KEY,
PrimerNombre VARCHAR(20) NOT NULL,
SegundoNombre VARCHAR(20), --Puede no tener segundo nombre--
PrimerApellido VARCHAR(20) NOT NULL,
SegundoApellido VARCHAR(20), --puede no tener segundo apellido--
CorreoElectronico VARCHAR(50)NOT NULL,
Telefono VARCHAR(50) NOT NULL,
Acompañantes INTEGER, 
CHECK(Acompañantes>=0 AND Acompañantes<=3),
PaisNacionalidad INTEGER REFERENCES Paises(IdPais)
);
GO


CREATE TABLE HuespedHabitacion(
NumeroRegistro INTEGER PRIMARY KEY,
FechaHoraLlegada DATETIME UNIQUE NOT NULL,
FechaHoraSalida DATETIME NOT NULL,
HuespedId INTEGER REFERENCES Huesped(IdHuesped),
HabitacionNumero INTEGER REFERENCES Habitacion(NumeroHabitacion),
HotelId INTEGER REFERENCES Hotel(IdHotel)
);
GO


------------------------------------------------------------------------------

CREATE TABLE Transaccional(
NumeroTransaccion INTEGER Identity(1,1) PRIMARY KEY,
FechaHora DATETIME NOT NULL UNIQUE,
NochesEstadia INTEGER REFERENCES HuespedHabitacion(NumeroRegistro),
);
GO


CREATE TABLE Pedido(
IdPedido INTEGER,
NumeroProducto INTEGER,
PRIMARY KEY (IdPedido, NumeroProducto),
Producto INTEGER REFERENCES ProductoRestaurante(IdProducto),
Transaccion INTEGER REFERENCES Transaccional(NumeroTransaccion)
);
GO
CREATE TABLE Servicio(
IdServicio INTEGER PRIMARY KEY,
NombreServicio VARCHAR(150) NOT NULL,
Descripcion VARCHAR(200) NOT NULL,
Precio INTEGER NOT NULL
);
GO


CREATE TABLE Factura(
NumeroFactura INTEGER IDENTITY(1,1) PRIMARY KEY,
Encabezado VARCHAR(100) NOT NULL,
Cliente INTEGER REFERENCES Huesped(IdHuesped),
Transaccion INTEGER REFERENCES Transaccional(NumeroTransaccion),
GastosServicios INTEGER REFERENCES Servicio(IdServicio),
MetodoPago BIT NOT NULL, -----------El 1 es pago en efectivo y 0 pago por tarjeta
Total DECIMAL(13,2) NOT NULL
);
GO


-------------------------------------------------------------------------------------

INSERT INTO Paises ( IdPais, Nombre, Nacionalidad) VALUES (1, 'Honduras', 'Hondureña');
GO

INSERT INTO Paises ( IdPais, Nombre, Nacionalidad) VALUES (2, 'Nicaragua', 'Nicaraguense');
GO

INSERT INTO Paises ( IdPais, Nombre, Nacionalidad) VALUES (3, 'Guatemala', 'Guatemalteca');
GO

SELECT*FROM Paises;
GO
-------------------------------------------------------------------------------------

INSERT INTO Departamentos (IdDepartamento,PaisId,Nombre)
VALUES(1,1, 'Francisco Morazan');
GO

INSERT INTO Departamentos (IdDepartamento,PaisId,Nombre)
VALUES(2,1, 'Santa Barbara');
GO

INSERT INTO Departamentos (IdDepartamento,PaisId,Nombre)
VALUES(3,2, 'Granada');
GO

INSERT INTO Departamentos (IdDepartamento,PaisId,Nombre)
VALUES(4,2, 'Managua');
GO

INSERT INTO Departamentos (IdDepartamento,PaisId,Nombre)
VALUES(5,3, 'Santa Rosa');
GO

INSERT INTO Departamentos (IdDepartamento,PaisId,Nombre)
VALUES(6,3, 'Guatemala');
GO

SELECT*FROM Departamentos;
GO
-------------------------------------------------------------------------------------

INSERT INTO Ciudades ( IdCiudad, PaisId, DepartamentoId, Nombre)
VALUES(1, 1, 1, 'Tegucigalpa');
GO

INSERT INTO Ciudades ( IdCiudad, PaisId, DepartamentoId, Nombre)
VALUES(2, 1, 2, 'Santa Barbara');
GO

INSERT INTO Ciudades ( IdCiudad, PaisId, DepartamentoId, Nombre)
VALUES(3, 1, 1, 'Valle De Angeles');
GO

INSERT INTO Ciudades ( IdCiudad, PaisId, DepartamentoId, Nombre)
VALUES(4, 1, 1, 'Danli');
GO

SELECT*FROM Ciudades;
GO
-------------------------------------------------------------------------------------

INSERT INTO Colonias (IdColonia, PaisId, DepartamentoId, CiudadId, Nombre)
VALUES(1,1,1,1,'Nueva Suyapa');
GO

INSERT INTO Colonias (IdColonia, PaisId, DepartamentoId, CiudadId, Nombre)
VALUES(2,1,1,1,'Brisas de Valle');
GO

INSERT INTO Colonias (IdColonia, PaisId, DepartamentoId, CiudadId, Nombre)
VALUES(3,1,1,1,'21 de Octubre');
GO

INSERT INTO Colonias (IdColonia, PaisId, DepartamentoId, CiudadId, Nombre)
VALUES(4,1,1,1,'Res. Las Palmas');
GO

SELECT*FROM Colonias; 
GO
-------------------------------------------------------------------------------------

INSERT INTO Direcciones (IdDireccion, ColoniaId, DepartamentoId, CiudadId, PaisId, Referencia) VALUES
(1,1,1,1,1, 'Frente a Pollos Sierra');
GO

INSERT INTO Direcciones (IdDireccion, ColoniaId, DepartamentoId, CiudadId, PaisId, Referencia) VALUES
(2,2,1,1,1, 'Dos cuadras al este de abarroteria EMIL');
GO

INSERT INTO Direcciones (IdDireccion, ColoniaId, DepartamentoId, CiudadId, PaisId, Referencia) VALUES
(3,1,1,1,1, 'Cuadra Arriba de la Posta Policial');
GO

INSERT INTO Direcciones (IdDireccion, ColoniaId, DepartamentoId, CiudadId, PaisId, Referencia) VALUES
(4,2,1,1,1, 'Cruzando el rio y una pequeña quebrada');
GO

SELECT*FROM Direcciones;
GO
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

INSERT INTO TipoProducto(IdTipoProducto, NombreTipo ) 
VALUES (1, 'Entrada')
GO

INSERT INTO TipoProducto(IdTipoProducto, NombreTipo ) 
VALUES (2, 'Plato fuerte')
GO

INSERT INTO TipoProducto(IdTipoProducto, NombreTipo ) 
VALUES (3, 'Postre')
GO

INSERT INTO TipoProducto(IdTipoProducto, NombreTipo ) 
VALUES (4, 'Bebida')
GO

SELECT * FROM TipoProducto;
GO
-------------------------------------------------------------------------------------

INSERT INTO ProductoRestaurante(IdProducto, Nombre, Ingredientes, Precio, Tipo) 
VALUES(	1001, 'Enchiladas', 'Carne, papas, tortillas, repollo', 40, 2);
																								
GO
Insert into ProductoRestaurante(IdProducto, Nombre, Ingredientes, Precio, Tipo) 
Values(	1002, 'Baleadas', 'Tortillas de Harina, Frijoles, Queso', 10, 1);
Go

Insert into ProductoRestaurante(IdProducto, Nombre, Ingredientes, Precio, Tipo) 
Values(	1003, 'Tacos Mexicanos','Tortillas, Carne de Res, Aderezo, Chile', 60, 2);
Go
Insert into ProductoRestaurante(IdProducto, Nombre, Ingredientes, Precio, Tipo) 
Values(	1004, 'Pastel de Chocolate', 'Harina, Chocolate, Soda, Azucar', 50, 3);

Go
Insert into ProductoRestaurante(IdProducto, Nombre, Ingredientes, Precio, Tipo) 
Values(	1005,'Coca Cola','Coca Cola', 20, 4);
Go
INSERT INTO ProductoRestaurante( IdProducto, Nombre, Ingredientes, Precio, Tipo) 
VALUES ( 1006, 'Panqueques', 'Harina, Leche, Huevos, Soda, miel', 35.00, 1)
GO

INSERT INTO ProductoRestaurante( IdProducto, Nombre, Ingredientes, Precio, Tipo) 
VALUES ( 1008, 'Sopa de Pollo', 'Pollo, Arroz, Papas, Yuca, Tomate, Chile, Cebolla, Apio', 95.00, 2)
GO

INSERT INTO ProductoRestaurante( IdProducto, Nombre, Ingredientes, Precio, Tipo) 
VALUES ( 1009, 'Costilla a la Barbacoa', 'Costilla de Cerdo, Arroz, Vegetales, Salsa Barbaco, Ensalada de Papas', 100.00, 2)
GO

INSERT INTO ProductoRestaurante( IdProducto, Nombre, Ingredientes, Precio, Tipo) 
VALUES ( 1010, 'Pastel de 3 leches', 'Harina, Leche condensada, , papas, yuca', 55.00, 3)
GO

INSERT INTO ProductoRestaurante( IdProducto, Nombre, Ingredientes, Precio, Tipo) 
VALUES ( 1011, 'Pastel de Limon', 'Harina, Soda, Mantequilla, Limón', 50.00, 3)
GO

INSERT INTO ProductoRestaurante( IdProducto, Nombre, Ingredientes, Precio, Tipo) 
VALUES ( 1012, 'Latte', 'Café, Leche, Azucar', 35.00, 4)
GO

SELECT * FROM ProductoRestaurante;
GO

-------------------------------------------------------------------------------------

INSERT INTO Hotel(IdHotel, Nombre, Telefono, CorreoElectronico, Direccion) VALUES(	1000,
																					'HOTEL EMPERADOR Honduras #1',
																					'91929394',
																					'hotelemperadorhn1@gmail.com',
																					1
																			);
GO
INSERT INTO Hotel(IdHotel, Nombre, Telefono, CorreoElectronico, Direccion) VALUES(	1001,
																					'HOTEL EMPERADOR #2',
																					'65481121',
																					'hotelemperadorhn2@gmail.com',
																					2
																			);
GO

SELECT * FROM Hotel;
GO
-------------------------------------------------------------------------------------

INSERT INTO Restaurante (IdRestaurante, Producto, HotelId) VALUES (100, 1011 , 1001);
GO

INSERT INTO Restaurante (IdRestaurante, Producto, HotelId) VALUES (101, 1005, 1001);
GO

SELECT * FROM Restaurante;
GO
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------


 INSERT INTO CargoEmpleado(IdCargo, NombreCargo, Descripcion, Sueldo) VALUES(	1001,
																				'Atencion al Cliente',
																				'Se encargan de atender las inquietudes que puedan tener los clientes, sobre los productos y servicios ofrecidos',
																				540
																			);
GO
INSERT INTO CargoEmpleado(IdCargo, NombreCargo, Descripcion, Sueldo) VALUES(	2001,
																				'Mantenimiento',
																				'se encargan de la revisi�n, acondicionamiento y reparaci�n de las instalaciones y Habitaciones del Hotel',
																				420
																			);
GO
INSERT INTO CargoEmpleado(IdCargo, NombreCargo, Descripcion, Sueldo) VALUES(	3001,
																				'Gerente',
																				'Controlar�, planificar� y organizar� el Hotel. Coordinara a las personas para poder lograr el cumplimento de cada uno de sus objetivos.',
																				800
																			);
GO
INSERT INTO CargoEmpleado(IdCargo, NombreCargo, Descripcion, Sueldo) VALUES(	4001,
																				'Camarero (Empleado del restaurante)',
																				'Toma la orden de cada cliente',
																				450
																			);
GO
INSERT INTO CargoEmpleado(IdCargo, NombreCargo, Descripcion, Sueldo) VALUES(	4002,
																				'Cocinero (Empleado del restaurante)',
																				'Ayudante del chef para preparar los alimentos a servir.',
																				500
																			);
GO
INSERT INTO CargoEmpleado(IdCargo, NombreCargo, Descripcion, Sueldo) VALUES(	4003,
																				'Chef (Empleado del restaurante)',
																				'Dirige todo lo que tiene que ver con cocinar y designar cargos a sus subordinados.',
																				650
																			);
GO

SELECT * FROM CargoEmpleado;
GO
-------------------------------------------------------------------------------------

INSERT INTO Empleado(IdEmpleado, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, CorreoElectronico, Telefono, Cargo, Direccion) VALUES(		1010,
																																							'Carlos',
																																							'Daniel',
																																							'Sanchez',
																																							'Hernandez',
																																							'carlossanchez@gmail.com',
																																							'80808080',
																																							1001,
																																							1
																																						);
GO
INSERT INTO Empleado(IdEmpleado, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, CorreoElectronico, Telefono, Cargo, Direccion) VALUES(		2010,
																																							'Jose',
																																							'Mario',
																																							'Perez',
																																							'Lopez',
																																							'joseperez@gmail.com',
																																							'80809090',
																																							2001,
																																							1
																																						);
GO
INSERT INTO Empleado(IdEmpleado, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, CorreoElectronico, Telefono, Cargo, Direccion) VALUES(		3010,
																																							'Keyla',
																																							'Nicolle',
																																							'Chacón',
																																							'Gutierrez',
																																							'keylachachon@gmail.com',
																																							'80801010',
																																							3001,
																																							2
																																						);
GO
INSERT INTO Empleado(IdEmpleado, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, CorreoElectronico, Telefono, Cargo, Direccion) VALUES(		4010,
																																							'Carlos',
																																							'Roberto',
																																							'Figueroa',
																																							'Martinez',
																																							'carlosfigueroa@gmail.com',
																																							'80808010',
																																							4001,
																																							2
																																						);
GO
INSERT INTO Empleado(IdEmpleado, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, CorreoElectronico, Telefono, Cargo, Direccion) VALUES(		4011,
																																							'Raul',
																																							'Antonio',
																																							'Espinoza',
																																							'Garcia',
																																							'raulespinoza@gmail.com',
																																							'80808020',
																																							4002,
																																							1
																																						);
GO
INSERT INTO Empleado(IdEmpleado, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, CorreoElectronico, Telefono, Cargo, Direccion) VALUES(		4012,
																																							'Alejandra',
																																							'Ester',
																																							'Amador',
																																							'Lopez',
																																							'alejandraamador@gmail.com',
																																							'80808030',
																																							4003,
																																							2
																																						);
GO

SELECT * FROM Empleado;
GO
-------------------------------------------------------------------------------------

INSERT INTO EmpleadoHoteles(IdPuesto, EmpleadoId, HotelId) VALUES(	20201,
																	1010,
																	1000
																	);
GO
INSERT INTO EmpleadoHoteles(IdPuesto, EmpleadoId, HotelId) VALUES(	20202,
																	2010,
																	1000
																	);
GO
INSERT INTO EmpleadoHoteles(IdPuesto, EmpleadoId, HotelId) VALUES(	20203,
																	3010,
																	1000
																	);
GO
INSERT INTO EmpleadoHoteles(IdPuesto, EmpleadoId, HotelId) VALUES(	20204,
																	4010,
																	1000
																	);
GO
INSERT INTO EmpleadoHoteles(IdPuesto, EmpleadoId, HotelId) VALUES(	20205,
																	4011,
																	1000
																	);
GO
INSERT INTO EmpleadoHoteles(IdPuesto, EmpleadoId, HotelId) VALUES(	20206,
																	4012,
																	1000
																	);
GO

SELECT * FROM EmpleadoHoteles;
GO
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

INSERT INTO TipoHabitacion(IdTipo, NombreTipo, NumeroCamas, Descripcion, Precio
) VALUES (1, 'Individual', 1, 'Puede hacer uso de servicios extra', 450);
GO

INSERT INTO TipoHabitacion(IdTipo, NombreTipo, NumeroCamas, Descripcion, Precio
) VALUES (2, 'doble', 1, 'Puede hacer uso de servicios extra', 900);
GO

INSERT INTO TipoHabitacion(IdTipo, NombreTipo, NumeroCamas, Descripcion, Precio
) VALUES (3, 'doble-doble', 2, 'Habitacion con dos camas matrimoniales', 1500);
GO

SELECT*FROM TipoHabitacion;
GO
-------------------------------------------------------------------------------------

INSERT INTO Habitacion(NumeroHabitacion, NumeroTelefono, Disponibilidad, HotelId, TipoId) 
VALUES(15, '2772-10-15', 0, 1000, 1); 
GO

INSERT INTO Habitacion(NumeroHabitacion, NumeroTelefono, Disponibilidad, HotelId, TipoId) 
VALUES(20, '2772-10-20', 0, 1000, 2); 
GO

INSERT INTO Habitacion(NumeroHabitacion, NumeroTelefono, Disponibilidad, HotelId, TipoId) 
VALUES(25, '2772-10-25', 0,1000, 3); 
GO

SELECT*FROM Habitacion;
GO
-------------------------------------------------------------------------------------

INSERT INTO Huesped(IdHuesped, PrimerNombre, SegundoNombre, PrimerApellido,SegundoApellido, CorreoElectronico, Telefono, Acompañantes, PaisNacionalidad)
VALUES (1, 'Angela', NULL, 'Carcamo', 'Ruiz', 'angela.21@gmail.com', '89-67-43-01', 0, 1);
GO
INSERT INTO Huesped(IdHuesped, PrimerNombre, SegundoNombre, PrimerApellido,SegundoApellido, CorreoElectronico, Telefono, Acompañantes, PaisNacionalidad)
VALUES (2, 'Jessica','Alejandra', 'Manzanares', 'Moreno', 'jmanzanares@gmail.com', '8947-1948', 1, 1);
GO
INSERT INTO Huesped(IdHuesped, PrimerNombre, SegundoNombre, PrimerApellido,SegundoApellido, CorreoElectronico, Telefono, Acompañantes, PaisNacionalidad)
VALUES (3, 'Francisco','Antonio', 'Izaguirre', 'Gomez', 'faizaguirre@hotmail.com', '9545-8978', 3, 2);
GO

SELECT*FROM Huesped;
GO
-------------------------------------------------------------------------------------

INSERT INTO HuespedHabitacion(NumeroRegistro, FechaHoraLlegada, FechaHoraSalida, HuespedId, HabitacionNumero, HotelId
) VALUES (1, '2020-02-12 8:10:06 AM', '2020-04-12 9:18:00 AM', 1, 15, 1000);
GO

INSERT INTO HuespedHabitacion(NumeroRegistro, FechaHoraLlegada, FechaHoraSalida, HuespedId, HabitacionNumero, HotelId
) VALUES (2, '2020-10-12 6:15:29 PM', '2020-11-12 12:01:50 AM', 2, 20, 1000);
GO

INSERT INTO HuespedHabitacion(NumeroRegistro, FechaHoraLlegada, FechaHoraSalida, HuespedId, HabitacionNumero, HotelId
) VALUES (3, '2020-15-12 1:39:05 PM', '2020-19-12 5:25:12 AM', 3, 25, 1000);
GO

SELECT*FROM HuespedHabitacion;
GO
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

INSERT INTO Transaccional(FechaHora, NochesEstadia)
VALUES('2020-02-12 8:30:22 AM', 2);
GO

INSERT INTO Transaccional(FechaHora, NochesEstadia)
VALUES('2020-02-12 11:59:00 AM', 1);
GO

SELECT * FROM Transaccional;
GO
-------------------------------------------------------------------------------------

Insert into Pedido(IdPedido, NumeroProducto, Producto, Transaccion) 
Values(	2002, 1, 1001, 1);
Go

Insert into Pedido(IdPedido, NumeroProducto, Producto, Transaccion) Values(	2002,
															2,
															1002,
															1
															);
Go
Insert into Pedido(IdPedido, NumeroProducto, Producto, Transaccion) Values(	2002,
															3,
															1003,
															1
															);
Go
Insert into Pedido(IdPedido, NumeroProducto, Producto, Transaccion) Values(	2002,
                                                            4,
															1004,
															1
															);
Go

Insert into Pedido(IdPedido, NumeroProducto, Producto, Transaccion) Values(	2002,
                                                             5,
															1005,
															1
															);
Go
Insert into Pedido(IdPedido, NumeroProducto, Producto, Transaccion) Values(	2002,
                                                            6,
															1005,
															1
															);
Go
Insert into Pedido(IdPedido, NumeroProducto, Producto, Transaccion) Values(	2003,
                                                            1,
															1005,
															2
															);
Go
-------------------------------------------------------------------------------------

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(1, 'Limpieza', 'Aseo completo de la habitacion', 200);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(2, 'Estacionamiento', 'Asegura un espacio de estacionamiento, durante su estadia', 200);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(3, 'Alberca', 'Disposicion de la alberca las 24 hrs, durante su estadia', 200);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(4, 'Gimnasio', 'Disposicion de la alberca las 24 hrs, durante su estadia', 200);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(5, 'Salon para Eventos', 'Horarios 7-11 AM, 1-5 PM', 200);
GO

SELECT * FROM Servicio;
GO
-------------------------------------------------------------------------------------

INSERT INTO Factura(Encabezado, Cliente, Transaccion, GastosServicios, Total, MetodoPago)
VALUES('HOTEL EMPERADOR  "comodidad, Bienestar y Servicio"', 3, 1, 3, 500, 0);
GO

INSERT INTO Factura(Encabezado,Cliente, Transaccion, GastosServicios, Total, MetodoPago)
VALUES('HOTEL EMPERADOR "comodidad, Bienestar y Servicio"', 1, 2, 2, 300, 1);
GO


SELECT * FROM Factura;
GO

