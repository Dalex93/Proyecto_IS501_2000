CREATE DATABASE HotelColonial;
GO
Use HotelColonial;
GO

CREATE TABLE Paises (
IdPais INTEGER PRIMARY KEY,
Nombre VARCHAR(100) NOT NULL,
Nacionalidad VARCHAR(100) NOT NULL
);
GO


INSERT INTO Paises VALUES
(1, 'Honduras', 'Hondureña');
GO

SELECT *FROM Paises;


CREATE TABLE Departamento (
IdDepartamento INTEGER PRIMARY KEY,
IdPais INTEGER FOREIGN KEY REFERENCES Paises(IdPais),
Nombre VARCHAR(100) NOT NULL
);
GO


INSERT INTO Departamento VALUES
(1,1, 'Francisco Morazan'),
(2,1, 'Comayagua'),
(3,1,'Atlantida'),
(4,1,'Colon'),
(5,1,'Cortes'),
(6,1,'Copan'),
(7,1,'Choluteca'),
(8,1,'El Paraiso'),
(9,1,'Gracias a Dios'),
(10,1,'Islas de la Bahia')
;
GO

SELECT *FROM Departamento;

CREATE TABLE TipoComida (
IdTipoComida INTEGER PRIMARY KEY,
NombreTipo VARCHAR(100) NOT NULL, 
);
GO


ALTER TABLE TipoComida ADD CONSTRAINT Tipos CHECK (
IdTipoComida=1 AND NombreTipo = 'Desayuno' OR
IdTipoComida=2 AND NombreTipo = 'Almuerzo' OR
IdTipoComida=3 AND NombreTipo = 'Cena'  
);
GO

INSERT INTO TipoComida VALUES 
(1, 'Desayuno'),
(2, 'Almuerzo'),
(3, 'Cena');
GO

SELECT *FROM TipoComida;

CREATE TABLE ComidaRestaurante(
IdComida INTEGER PRIMARY KEY NOT NULL,
Nombre VARCHAR (100) NOT NULL,
Guarnicion VARCHAR (500) NOT NULL, 
Precio DECIMAL (13,2) NOT NULL,
CHECK (Precio>=0),
Tipo INTEGER FOREIGN KEY REFERENCES TipoComida (IdTipoComida) 
);
GO


INSERT INTO ComidaRestaurante VALUES
(101, 'Pollo a la Plancha' , 'Papas, tortillas, chimichurri', 90, 3),
(102, 'Huevos Rancheros','Frijoles, Platano, cafe', 70, 1),
(103, 'Pasta Alfredo', 'Pan de Ajo', 150, 2),
(104, 'Gordon Blue' , 'Pure de Papas', 130, 2),
(105, 'Desayuno Tipico','Frijoles, Huevos estrellados, Salchicha, Carne de Cerdo', 60, 1),
(106, 'Camarones Al Ajillo', 'Pan de Ajo, Papas Fritas, Ensalada de Lechuga', 210, 3),
(107, 'Pezcado Frito', 'Tajadas, Pico de Gallo, Rise and Beans', 180, 2),
(108, 'Baleadas', 'Platano, Huevo, Aguacate', 45, 1),
(109, 'Sopa Marinera', 'Tortillas, , Arroz', 210, 2),
(110, 'Club Sandwich', 'Papas Fritas', 210, 3)
;
GO

SELECT *FROM ComidaRestaurante;



CREATE TABLE Hotel(
IdHotel INTEGER PRIMARY KEY NOT NULL,
Nombre VARCHAR(50) NOT NULL,
Departamento INTEGER REFERENCES Departamento(IdDepartamento),
Telefono VARCHAR(20) NOT NULL,
Correo VARCHAR(250) NOT NULL,				
);
GO 


INSERT INTO Hotel VALUES
(100,'Hotel Colonial Tegucigalpa #1',1,'2200-8090','hcolonialhn1@gmail.com'),
(101,'Hotel Colonial San Pedro Sula #2',2,'2233-8090','hcolonialhn2@gmail.com'),
(102,'Hotel Colonial Comayagua #3',3,'2237-8090','hcolonialhn3@gmail.com'),
(103,'Hotel Colonial Atlantida #4',4,'2239-8090','hcolonialhn4@gmail.com'),
(104,'Hotel Colonial Colon #5',5,'2239-8090','hcolonialhn5@gmail.com'),
(105,'Hotel Colonial Trujillo #6',6,'2240-8090','hcolonialhn6@gmail.com')
;
GO
SELECT *FROM Hotel;

CREATE TABLE Restaurante (
IdRestaurante INTEGER PRIMARY KEY NOT NULL,
IdComida INTEGER FOREIGN KEY REFERENCES ComidaRestaurante (IdComida),
HotelId INTEGER REFERENCES Hotel(IdHotel)
);
GO




INSERT INTO Restaurante VALUES 
(100, 102 , 101),
(101, 103, 105),
(102, 104 , 104),
(103, 107, 102),
(104, 106 , 103),
(105, 101, 102);
GO

SELECT * FROM Restaurante;
GO
---------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE CargoEmpleado(
IdCargo INTEGER PRIMARY KEY NOT NULL,
NombreCargo VARCHAR(100) NOT NULL,
Descripcion VARCHAR(300) NOT NULL,
Sueldo DECIMAL(13,2) NOT NULL
);
GO


INSERT INTO CargoEmpleado VALUES
(1001,'Atencion al Cliente','Proporciona informacion los clientes,
 sobre los productos y servicios ofrecidos',500),

(1002,'Mantenimiento','se encargan del acondicionamiento y reparacion de las instalaciones y Habitaciones del Hotel',450),

(1003,'Gerente','Controla, planifica y organiza el Hotel.',1000),

(1004,'Camarero (Empleado del restaurante)','Toma la orden de cada cliente',450),

(1005,'Cocinero (Empleado del restaurante)','Ayudante del chef para preparar los alimentos.',600),

(1006,'Chef (Empleado del restaurante)','Dirige todo lo que tiene que ver con la cocina y asigna cargos a sus subordinados.'
,850),

(1007,'Limpieza','Ordena y mantiene limpio el hotel y sus habitaciones'
,500);
GO

SELECT * FROM CargoEmpleado;
GO

CREATE TABLE Empleado(
IdEmpleado INTEGER PRIMARY KEY NOT NULL,
PrimerNombre VARCHAR(50) NOT NULL,
SegundoNombre VARCHAR(50),
PrimerApellido VARCHAR(50) NOT NULL,
SegundoApellido VARCHAR(50),
CorreoElectronico VARCHAR(250) NOT NULL,
Telefono VARCHAR(50) NOT NULL,
Cargo INTEGER REFERENCES CargoEmpleado(IdCargo)
);
GO

ALTER TABLE Empleado Add CONSTRAINT CargoCk CHECK(
		Cargo=1001 OR
		Cargo=1002 OR
		Cargo=1003 OR
		Cargo=1004 OR
		Cargo=1005 OR
		Cargo=1006 OR
		Cargo=1007 
);
GO

INSERT INTO Empleado VALUES
(1010,'Santos','Isabel','Munguia','Hernandez','isabel11@gmail.com',99126292,1003),
(1011,'Victor','Manuel','Montes','Rodas','montes16@gmail.com',99946292,1001),
(1012,'Jose','carlos','Aguilar','Lopez','carlos07@gmail.com',99976292,1002),
(1013,'Eliud','Obed','Rivera','Rodriguez','Eliud05@gmail.com',34033406,1004),
(1014,'Bessy','Carolina','Aguilar','Munguia','carolina03@gmail.com',33941092,1005),
(1015,'Victor','Aurelio','Ramirez','Posadas','ramirez98@gmail.com',32946292,1006),
(1017,'Deyvid','James','Aguilar','Rivera','james18@gmail.com',95446292,1007);
GO
										

SELECT *FROM Empleado;

CREATE TABLE EmpleadoHotel(
IdPuesto INTEGER PRIMARY KEY,
IdEmpleado INTEGER REFERENCES Empleado(IdEmpleado),
HotelId INTEGER REFERENCES Hotel(IdHotel)
);
GO


INSERT INTO EmpleadoHotel VALUES
(2021,1010,100),
(2022,1011,101),
(2023,1012,102),
(2024,1013,103),
(2025,1014,104),
(2026,1015,105);
GO
SELECT *FROM EmpleadoHotel;

CREATE TABLE TipoHabitacion(
IdTipo INTEGER PRIMARY KEY,
Nombre VARCHAR(100)NOT NULL,
NumeroCamas INTEGER NOT NULL,
Descripcion VARCHAR(100) NOT NULL,
Precio DECIMAL(13,2) NOT NULL
);
GO

ALTER TABLE TipoHabitacion ADD CONSTRAINT CK_NombreTipo CHECK(
IdTipo=1 AND Nombre='individual' OR
IdTipo=2 AND Nombre='doble' OR
IdTipo=3 AND Nombre='doble-doble' OR
IdTipo=4 AND Nombre='triple' OR
IdTipo=5 AND Nombre='quad' OR
IdTipo=6 AND Nombre='king' OR
IdTipo=7 AND Nombre='queen' OR
IdTipo=8 AND Nombre='suite ejecutiva' OR
IdTipo=9 AND Nombre='suite presidencial' OR
IdTipo=10 AND Nombre='estadias prolongadas');
GO

INSERT INTO TipoHabitacion(IdTipo, Nombre, NumeroCamas, Descripcion, Precio
) VALUES (1, 'individual', 1, 'Puede hacer uso de servicios extra', 450);
GO

INSERT INTO TipoHabitacion(IdTipo, Nombre, NumeroCamas, Descripcion, Precio
) VALUES (2, 'doble', 1, 'Puede hacer uso de servicios extra', 900);
GO

INSERT INTO TipoHabitacion(IdTipo, Nombre, NumeroCamas, Descripcion, Precio
) VALUES (3, 'doble-doble', 2, 'Habitacion con dos camas matrimoniales', 1500);
GO

INSERT INTO TipoHabitacion(IdTipo, Nombre, NumeroCamas, Descripcion, Precio
) VALUES (4, 'triple', 3, 'Habitacion con tres camas individuales, una cama doble y una cama individual o dos camas dobles', 2500);
GO

INSERT INTO TipoHabitacion(IdTipo, Nombre, NumeroCamas, Descripcion, Precio
) VALUES (5, 'quad', 4, 'Una habitación asignada a cuatro personas. Puede tener dos o más camas.', 3500);
GO

INSERT INTO TipoHabitacion(IdTipo, Nombre, NumeroCamas, Descripcion, Precio
) VALUES (6, 'king', 1, 'Una habitación con una cama king-size. Puede ser ocupado por una o más personas.', 1350);
GO


SELECT*FROM TipoHabitacion;
GO

CREATE TABLE Habitacion(
NumeroHabitacion INTEGER PRIMARY KEY,
Telefono VARCHAR(50) NOT NULL,
Disponibilidad BIT NOT NULL,--No Disponible=1, Disponible=0-- 
HotelId INTEGER REFERENCES Hotel(IdHotel),
TipoId INTEGER REFERENCES TipoHabitacion(IdTipo) 
); 
GO

INSERT INTO Habitacion(NumeroHabitacion, Telefono, Disponibilidad, HotelId, TipoId) 
VALUES(1, '9920-21-22', 0, 100, 1); 
GO

INSERT INTO Habitacion(NumeroHabitacion, Telefono, Disponibilidad, HotelId, TipoId) 
VALUES(2, '3333-20-19', 0, 100, 2); 
GO

INSERT INTO Habitacion(NumeroHabitacion, Telefono, Disponibilidad, HotelId, TipoId) 
VALUES(3, '2232-23-22', 0,100, 3); 
GO

SELECT*FROM Habitacion;
GO

CREATE TABLE TipoHuesped(
IdTipoHuesped INTEGER PRIMARY KEY,
Nombre VARCHAR(20)
);
GO


INSERT INTO TipoHuesped(IdTipoHuesped, Nombre) VALUES
						(1,'Turista'),
						(2,'Familia'),
						(3,'Adulto Mayor'),
						(4,'VIP'),
						(5,'Habitual'),
						(6,'Potencial')
GO

SELECT * FROM TipoHuesped;

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
PaisId INTEGER REFERENCES Paises(IdPais),
TipoHuesped INTEGER REFERENCES TipoHuesped(IdTipoHuesped)
);
GO



INSERT INTO Huesped(IdHuesped, PrimerNombre, SegundoNombre, PrimerApellido,SegundoApellido, CorreoElectronico, Telefono, Acompañantes, PaisId,TipoHuesped)
VALUES (1, 'David', 'Alexander', 'Cardenas', 'Almendares', 'dalex10@hotmail.com', '9964-0090', 0, 1,1);
GO
INSERT INTO Huesped(IdHuesped, PrimerNombre, SegundoNombre, PrimerApellido,SegundoApellido, CorreoElectronico, Telefono, Acompañantes, PaisId,TipoHuesped)
VALUES (2, 'Yoselin', 'Dayriela', 'Montes', 'Munguia', 'yoselin@gmail.com', '9620-0916', 1, 1,5);
GO

SELECT*FROM Huesped;
GO


-------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE Transigencia(
NumeroTransigencia INTEGER Identity(1,1) PRIMARY KEY,

FechaHora DATETIME NOT NULL UNIQUE,
NochesEstadia INTEGER NOT NULL,

);
GO

INSERT INTO Transigencia(FechaHora, NochesEstadia)
VALUES('2020-02-12 8:30:22 AM', 2);
GO

INSERT INTO Transigencia(FechaHora, NochesEstadia)
VALUES('2020-02-12 11:59:00 AM', 1);
GO

SELECT * FROM Transigencia;
GO

-------------------------------------------------------------------------------------


-----------------------------------------------------
CREATE TABLE Orden(
IdOrden INTEGER PRIMARY KEY,
IdComida INTEGER,
PrecioOrden INTEGER,
Transaccion INTEGER REFERENCES Transigencia(NumeroTransigencia)
);
GO

Insert into Orden(IdOrden, IdComida, PrecioOrden, Transaccion) 
Values(	2002, 1, 400, 1);
Go

Insert into Orden(IdOrden, IdComida,PrecioOrden, Transaccion) 
Values(	2002, 2, 300, 1);
Go

SELECT * FROM Orden;
GO

-------------------------------------------------
CREATE TABLE HuespedHabitacion(
NumeroRegistro INTEGER PRIMARY KEY,
FechaHoraLlegada DATETIME UNIQUE NOT NULL,
FechaHoraSalida DATETIME NOT NULL,
HuespedId INTEGER REFERENCES Huesped(IdHuesped),
HabitacionNumero INTEGER REFERENCES Habitacion(NumeroHabitacion),
HotelId INTEGER REFERENCES Hotel(IdHotel),
);
GO

INSERT INTO HuespedHabitacion(NumeroRegistro, FechaHoraLlegada, FechaHoraSalida, HuespedId, HabitacionNumero, HotelId
) VALUES (1, '2021-11-04 10:10:09 AM', '2021-12-04 10:18:00 AM', 1, 1, 100);
GO

INSERT INTO HuespedHabitacion(NumeroRegistro, FechaHoraLlegada, FechaHoraSalida, HuespedId, HabitacionNumero, HotelId
) VALUES (2, '2021-06-04 6:15:29 PM', '2021-06-12 12:01:50 AM', 2, 2, 100);
GO

INSERT INTO HuespedHabitacion(NumeroRegistro, FechaHoraLlegada, FechaHoraSalida, HuespedId, HabitacionNumero, HotelId
) VALUES (3, '2021-03-04 1:39:05 PM', '2021-03-05 5:25:12 PM', 2, 2, 100);
GO


SELECT*FROM HuespedHabitacion;
GO

-------------------------
SELECT * From TipoHabitacion, Transigencia  SELECT Precio, NochesEstadia, (precio*NochesEstadia) as CostoNoche,(((precio*NochesEstadia)*18)/100) As Impuesto,((precio*NochesEstadia) + (((precio*NochesEstadia)*18)/100)) As Total    From TipoHabitacion, Transigencia 
------------------------------------------------------

CREATE TABLE Servicio(
IdServicio INTEGER PRIMARY KEY,
NombreServicio VARCHAR(150) NOT NULL,
Descripcion VARCHAR(200) NOT NULL,
Precio INTEGER NOT NULL
);
GO


INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(1, 'Limpieza', 'Aseo completo de la habitacion', 200);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(2, 'Estacionamiento', 'Asegura un espacio de estacionamiento, durante su estadia', 200);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(3, 'Alberca', 'Disposicion de la alberca las 24 hrs, durante su estadia', 100);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(4, 'Gimnasio', 'Disposicion de la alberca las 24 hrs, durante su estadia', 700);
GO

INSERT INTO Servicio(IdServicio, NombreServicio, Descripcion, Precio)
VALUES(5, 'Salon para Eventos', 'Horarios 7-11 AM, 1-5 PM', 200);
GO

SELECT * FROM Servicio;
GO
-----------------------------------------------------------------------------------

----------------------------------------------------------------------

CREATE TABLE FacturaSAR(
 IdFactura INTEGER  PRIMARY KEY,
 Cliente INTEGER REFERENCES Huesped(IdHuesped),
Transaccion INTEGER REFERENCES Transigencia(CodigoDeTransigencia),
  GastosServicio  INTEGER REFERENCES Servicio(IdServicio),
 NochesEstadia INTEGER NOT NULL,
 PagoHabitacion INTEGER NOT NULL,
 PagoAlimentos INTEGER NOT NULL,
 PagoHospedaje AS (PagoHabitacion*NochesEstadia) PERSISTED NOT NULL,
 PagosExtra AS (PagoServicio + PagoAlimentos) PERSISTED NOT NULL,
 Impuesto AS  (((PagoHospedaje*NochesEstadia)*18)/100)  PERSISTED      NOT NULL,
 Total AS (PagoHospedaje+Impuesto) PERSISTED NOT NULL,
 );
GO