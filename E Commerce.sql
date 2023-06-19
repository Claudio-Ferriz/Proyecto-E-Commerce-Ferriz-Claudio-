CREATE SCHEMA `e_commerce_model`;
USE `e_commerce_model`;
-- Tables E Commerce
-- Table: Compras
CREATE TABLE Compras (
    ID_Compras int NOT NULL AUTO_INCREMENT,  
    Fecha_y_Hora datetime NOT NULL, 
    ID_Usuario int NOT NULL,
    Importe_Total float NOT NULL,
    Total_con_IVA float NOT NULL,
    ID_Forma_Pago int NOT NULL,
    ID_Direccion int NOT NULL,
    CONSTRAINT PK_Compras PRIMARY KEY (ID_Compras, ID_Usuario, ID_Forma_Pago, ID_Direccion)
);

-- Table: Usuario
CREATE TABLE Usuario (
    ID_Usuario int NOT NULL AUTO_INCREMENT,
    Nombre_y_Apellido varchar(50) NOT NULL,
    Tipo_Documento enum('DNI','DU','LE') NOT NULL,
    Numero_Documento varchar(50) NOT NULL,
    Email varchar(50) NOT NULL,
    Numero_Telefono varchar(50) NOT NULL,
    Password varchar(50) NOT NULL,
    CONSTRAINT PK_Usuario PRIMARY KEY (ID_Usuario)
);

-- Table: Producto
CREATE TABLE Producto (
    ID_Producto int NOT NULL AUTO_INCREMENT,
    Nombre_Producto varchar(50) NOT NULL,
    Precio float NOT NULL,
    Categoria enum('Alimentos', 'Electronica', 'Indumentaria') NOT NULL,
    ID_Subcategoria int NOT NULL,
    Numero_Serie varchar(50) NOT NULL,
    CONSTRAINT PK_Producto PRIMARY KEY (ID_Producto, ID_Subcategoria)
);

-- Table: Subcategoria
CREATE TABLE Subcategoria (
    ID_Subcategoria int NOT NULL AUTO_INCREMENT,
    Subcategoria varchar(50) NOT NULL,
    CONSTRAINT PK_Producto PRIMARY KEY (ID_Subcategoria)
);

-- Table: Proveedor
CREATE TABLE Proveedor (
    ID_Proveedor int NOT NULL AUTO_INCREMENT,
    Nombre_Razon_Social varchar(50) NOT NULL,
    Numero_Telefono_Proveedor varchar(20) NOT NULL,
    Pagina_Web varchar(50),
    Email_Proveedor varchar(50) NOT NULL,
    CONSTRAINT PK_Proveedor PRIMARY KEY (ID_Proveedor)
);

-- Table: Direccion de Envio
CREATE TABLE Direccion_Envio (
    ID_Direccion int NOT NULL AUTO_INCREMENT,
    Provincia enum('Buenos Aires', 'Santa Fe') NOT NULL,
    ID_Ciudad int NOT NULL,
    Direccion varchar(50) NOT NULL,
    Altura varchar(50) NOT NULL,
    Piso varchar(20),
    Departamento varchar(20),
    Codigo_Postal int NOT NULL,
    CONSTRAINT PK_Direccion_Envio PRIMARY KEY (ID_Direccion, ID_Ciudad)
);

-- Table: Ciudad
CREATE TABLE Ciudad (
    ID_Ciudad int NOT NULL AUTO_INCREMENT,
    Ciudad varchar(50) NOT NULL,
    CONSTRAINT PK_Ciudad PRIMARY KEY (ID_Ciudad)
);

-- Table: Oferta
CREATE TABLE Oferta (
    ID_Oferta int NOT NULL AUTO_INCREMENT,
    Porcentaje_Descuento int NOT NULL,
    Fecha_Inicio_Oferta datetime NOT NULL,
    Fecha_Cierre_Oferta datetime NOT NULL,
    ID_Producto int NOT NULL,
    CONSTRAINT PK_OFerta PRIMARY KEY (ID_Oferta, ID_Producto)
);

-- Table: Forma de Pago
CREATE TABLE Forma_Pago (
    ID_Forma_Pago int NOT NULL AUTO_INCREMENT,
    Tipo_Pago enum('Tarjeta de Debito', 'Tarjeta de Credito', 'Transferencia Bancaria') NOT NULL,
    Cuotas int NOT NULL,
    CONSTRAINT PK_Forma_Pago PRIMARY KEY (ID_Forma_Pago)
);

-- Table: Compras de Producto
CREATE TABLE Compras_Producto (
    ID_Compras int NOT NULL,
    ID_Producto int NOT NULL,
    Precio float NOT NULL,
    Cantidad int NOT NULL,
    CONSTRAINT PK_Compras_Producto PRIMARY KEY (ID_Compras, ID_Producto)
);

-- Table: Proveedor de Producto
CREATE TABLE Proveedor_Producto (
    ID_Proveedor int NOT NULL,
    ID_Producto int NOT NULL,
    Cantidad_Stock int NOT NULL,
    CONSTRAINT PK_Proveedor_Producto PRIMARY KEY (ID_Proveedor, ID_Producto)
);

-- Foreign Keys
-- Reference: FK_Compras_Usuario (table: Compras)
ALTER TABLE Compras ADD CONSTRAINT FK_Compras_Usuario FOREIGN KEY FK_Compras_Usuario (ID_Usuario)
    REFERENCES Usuario (ID_Usuario);

-- Reference: FK_Compras_Forma_Pago (table: Compras)  
ALTER TABLE Compras ADD CONSTRAINT FK_Compras_Forma_Pago FOREIGN KEY FK_Compras_Forma_Pago (ID_Forma_Pago)
    REFERENCES Forma_Pago (ID_Forma_Pago);    

-- Reference: FK_Compras_Direccion_Envio (table: Compras)  
ALTER TABLE Compras ADD CONSTRAINT FK_Compras_Direccion_Envio FOREIGN KEY FK_Compras_Direccion_Envio (ID_Direccion)
    REFERENCES Direccion_Envio (ID_Direccion);

-- Reference: FK_Producto_Subcategoria (table: Producto)  
ALTER TABLE Producto ADD CONSTRAINT FK_Producto_Subcategoria FOREIGN KEY FK_Producto_Subcategoria (ID_Subcategoria)
    REFERENCES Subcategoria (ID_Subcategoria);

-- Reference: FK_Direccion_Envio_Ciudad (table: Direccion_Envio)  
ALTER TABLE Direccion_Envio ADD CONSTRAINT FK_Direccion_Envio_Ciudad FOREIGN KEY FK_Direccion_Envio_Ciudad (ID_Ciudad)
    REFERENCES Ciudad (ID_Ciudad);

-- Reference: FK_Oferta_Producto (table: Oferta)  
ALTER TABLE Oferta ADD CONSTRAINT FK_Oferta_Producto FOREIGN KEY FK_Oferta_Producto (ID_Producto)
    REFERENCES Producto (ID_Producto);

-- Reference: FK_Compras_Producto_Compras (table: Compras_Producto)  
ALTER TABLE Compras_Producto ADD CONSTRAINT FK_Compras_Producto_Compras FOREIGN KEY FK_Compras_Producto_Compras (ID_Compras)
    REFERENCES Compras (ID_Compras);
    
-- Reference: FK_Compras_Producto_Producto (table: Compras_Producto)  
ALTER TABLE Compras_Producto ADD CONSTRAINT FK_Compras_Producto_Producto FOREIGN KEY FK_Compras_Producto_Producto (ID_Producto)
    REFERENCES Producto (ID_Producto);

-- Reference: FK_Proveedor_Producto_Proveedor (table: Proveedor_Producto)  
ALTER TABLE Proveedor_Producto ADD CONSTRAINT FK_Proveedor_Producto_Proveedor FOREIGN KEY FK_Proveedor_Producto_Proveedor (ID_Proveedor)
    REFERENCES Proveedor (ID_Proveedor);
    
-- Reference: FK_Proveedor_Producto_Producto (table: Proveedor_Producto)  
ALTER TABLE Proveedor_Producto ADD CONSTRAINT FK_Proveedor_Producto_Producto FOREIGN KEY FK_Proveedor_Producto_Producto (ID_Producto)
    REFERENCES Producto (ID_Producto);    

-- Views
-- View: Proveedores
CREATE OR REPLACE VIEW Proveedores AS
    (SELECT DISTINCT ID_Proveedor, pr.ID_Producto, Cantidad_Stock, Nombre_Producto
     FROM Proveedor_Producto pr JOIN Producto p ON (pr.ID_Producto = p.ID_Producto)
     ORDER BY Cantidad_Stock ASC);

-- View: Buenos Aires
CREATE OR REPLACE VIEW Buenos_Aires AS
    (SELECT DISTINCT d.ID_Direccion, Provincia, ID_Ciudad, Codigo_Postal, ID_Compras, Fecha_y_Hora
     FROM Direccion_Envio d JOIN Compras c ON (d.ID_Direccion = c.ID_Direccion)
     WHERE Provincia = 'Buenos Aires');

-- View: Ofertas
CREATE OR REPLACE VIEW Ofertas AS
    (SELECT DISTINCT ID_Oferta, Porcentaje_Descuento, Fecha_Inicio_Oferta, Fecha_Cierre_Oferta, o.ID_Producto, Nombre_Producto
     FROM Oferta o JOIN Producto p ON (o.ID_Producto = p.ID_Producto)
     ORDER BY Porcentaje_Descuento DESC);

-- View: Productos Comprados
CREATE OR REPLACE VIEW Productos_Comprados AS
    (SELECT DISTINCT ID_Compras, cp.ID_Producto, cp.Precio, Cantidad, Nombre_Producto
     FROM Compras_Producto cp JOIN Producto p ON (cp.ID_Producto = p.ID_Producto)
     ORDER BY Nombre_Producto ASC);

-- View: Formas de Pago
CREATE OR REPLACE VIEW Formas_Pago AS
    (SELECT DISTINCT ID_Compras, Fecha_y_Hora, Importe_Total, Total_con_IVA, c.ID_Forma_Pago, Tipo_Pago, Cuotas
     FROM Compras c JOIN Forma_Pago fp ON (c.ID_Forma_Pago = fp.ID_Forma_Pago)
     ORDER BY Tipo_Pago ASC);

-- Functions
-- Function: Calcular Monto Total Periodo
DELIMITER $$
USE `e_commerce_model`; $$
CREATE FUNCTION `Calcular_monto_periodo`(Fecha_inicio DATETIME, Fecha_cierre DATETIME) 
RETURNS FLOAT
DETERMINISTIC
BEGIN
  DECLARE Resultado FLOAT;
  SET Resultado = (SELECT SUM(Importe_Total) FROM Compras WHERE Fecha_y_Hora BETWEEN Fecha_inicio AND Fecha_Cierre);
  RETURN Resultado;
END  $$

DELIMITER $$      

-- Function: Calcular Porcentaje
DELIMITER $$
USE `e_commerce_model`; $$
CREATE FUNCTION `Calcular_porcentaje`(Precio_producto FLOAT, Porcentaje_total INT) 
RETURNS FLOAT
DETERMINISTIC
BEGIN
  DECLARE Resultado FLOAT;
  SET Resultado = Precio_producto - (Precio_producto * Porcentaje_total / 100);
  RETURN Resultado;
END  $$

DELIMITER $$ 

-- Prueba de las Funciones
-- Function: Calcular monto total periodo
SELECT Calcular_monto_periodo ('2023-04-20 17:34:22', '2023-05-20 17:39:47') AS Total_Periodo;

-- Function: Calcular Porcentaje
SELECT Calcular_porcentaje (300000.00, 20) AS Precio_con_Descuento; 

-- Stored Procedures
-- Stored Procedure: Sumar el Total de Productos Comprados 
USE `e_commerce_model`; 

DELIMITER $$
CREATE PROCEDURE `Total_Productos_Comprados` (OUT Total INT)
BEGIN
   SET total = (
   SELECT SUM(Cantidad) 
   FROM Compras_Producto);
END  $$

DELIMITER $$ 

-- Stored Procedure: Distribucion de envios por Ciudad  
USE `e_commerce_model`; 

DELIMITER $$
CREATE PROCEDURE `Distribucion_Envio_Ciudad` (IN Ciudad_Seleccionada INT, OUT Total_Ciudad INT)
BEGIN
   SELECT COUNT(*) INTO Total_Ciudad 
   FROM Direccion_Envio 
   WHERE ID_Ciudad = Ciudad_Seleccionada;
END  $$

DELIMITER $$ 

-- Prueba de los Stored Procedures
-- Stored Procedure: Sumar el Total de Productos Comprados
CALL Total_Productos_Comprados(@Total);
SELECT @Total;

-- Stored Procedure: Distribucion de Envios por Ciudad
CALL Distribucion_Envio_Ciudad( 1, @Total_Ciudad);
SELECT @Total_Ciudad;

-- Triggers
-- Creación de la Tabla Auditorias cuya función es generar registros historicos de INSERT, UPDATE y DELETE dentro de la Tabla Compras y dentro de la Tabla Producto al momento de generar o modificar un registro de las mismas. 
-- Table: Auditorias
CREATE TABLE Auditorias (
    ID_Log int AUTO_INCREMENT,
    Entity varchar(50),
    Entity_ID int,
    Insert_DT datetime,
    Created_by varchar(50),
    Last_Update_DT datetime,
    Last_Updated_by varchar(50),
    CONSTRAINT PK_Auditorias_Compras PRIMARY KEY (ID_Log)
);

SELECT * FROM Auditorias;

-- Trigger: Insert Compras y Auditorias
-- Trigger que se activa al momento del generar un nuevo registro de la Tabla Compras y que mediante un AFTER se generara un registro dentro de Auditorias por la nueva inserción en la primera Tabla.
CREATE TRIGGER `Tr_Insert_Compras_Aud`
AFTER INSERT ON `Compras`
FOR EACH ROW 
INSERT INTO `Auditorias`(Entity, Entity_ID, Insert_DT, Created_by, Last_Update_DT, Last_Updated_by)
VALUES ('Compras', NEW.ID_Compras, CURRENT_TIMESTAMP(), USER(), CURRENT_TIMESTAMP(), USER());

-- Trigger: Update Compras y Auditorias
-- Trigger que se activa al momento de hacer una actualización en un registro ya generado de la Tabla Compras y que mediante un AFTER se generara un registro dentro de Auditorias por dicha actualización.
CREATE TRIGGER `Tr_Update_Compras_Aud`
AFTER UPDATE ON `Compras`
FOR EACH ROW 
UPDATE `Auditorias` SET Last_Update_DT = CURRENT_TIMESTAMP(), Last_Updated_by = USER()
WHERE Entity_ID = OLD.ID_Compras;

-- Trigger: Delete Compras y Auditorias
-- Trigger que se activa al momento de borrar un registro de la Tabla Compras y que mediante un AFTER se generara un registro dentro de Auditorias por dicha acción.
CREATE TRIGGER `Tr_Delete_Compras_Aud`
AFTER DELETE ON `Compras`
FOR EACH ROW 
UPDATE `Auditorias` SET Last_Update_DT = CURRENT_TIMESTAMP(), Last_Updated_by = USER()
WHERE Entity_ID = OLD.ID_Compras;

-- Trigger: Insert Producto y Auditorias
-- Trigger que se activa al momento del generar un nuevo registro de la Tabla Producto y que mediante un AFTER se generara un registro dentro de Auditorias por la nueva inserción en la primera Tabla.
CREATE TRIGGER `Tr_Insert_Producto_Aud`
AFTER INSERT ON `Producto`
FOR EACH ROW 
INSERT INTO `Auditorias`(Entity, Entity_ID, Insert_DT, Created_by, Last_Update_DT, Last_Updated_by)
VALUES ('Producto', NEW.ID_Producto, CURRENT_TIMESTAMP(), USER(), CURRENT_TIMESTAMP(), USER());

-- Trigger: Update Producto y Auditorias
-- Trigger que se activa al momento de hacer una actualización en un registro ya generado de la Tabla Producto y que mediante un AFTER se generara un registro dentro de Auditorias por dicha actualización.
CREATE TRIGGER `Tr_Update_Producto_Aud`
AFTER UPDATE ON `Producto`
FOR EACH ROW 
UPDATE `Auditorias` SET Last_Update_DT = CURRENT_TIMESTAMP(), Last_Updated_by = USER()
WHERE Entity_ID = OLD.ID_Producto;

-- Trigger: Delete Producto y Auditorias
-- Trigger que se activa al momento de borrar un registro de la Tabla Producto y que mediante un AFTER se generara un registro dentro de Auditorias por dicha acción.
CREATE TRIGGER `Tr_Delete_Producto_Aud`
AFTER DELETE ON `Producto`
FOR EACH ROW 
UPDATE `Auditorias` SET Last_Update_DT = CURRENT_TIMESTAMP(), Last_Updated_by = USER()
WHERE Entity_ID = OLD.ID_Producto;

-- Creación de la Tabla Historial de Precio de Producto cuya función es tener registros historicos UPDATE por las actualizaciones de la columna Precio dentro de la Tabla Producto.
-- Table: Historial de Precio de Producto
CREATE TABLE Historial_Precio_Producto (
    ID_Producto int,
    Nombre_Producto varchar(50),
    Precio float,
    CONSTRAINT PK_Historial_Precio_Producto PRIMARY KEY (ID_Producto)
);

SELECT * FROM Historial_Precio_Producto;

-- Trigger: Update Precio de la Tabla Producto e Historial de Precio de Producto 
-- Trigger que se activa al momento de hacer una actualización en una columna Precio de la Tabla Producto y que mediante un AFTER se generara un registro OLD.Precio dentro de la Tabla Producto e Historial de Precio de Producto.
CREATE TRIGGER `Tr_Insert_Historial_Precio_Producto`
AFTER UPDATE ON `Producto`
FOR EACH ROW 
INSERT INTO `Historial_Precio_Producto`(ID_Producto, Nombre_Producto, Precio)
VALUES (OLD.ID_Producto, OLD.Nombre_Producto, OLD.Precio);

-- Trigger: Insert Importe Total con IVA dentro la Tabla Compras 
-- Trigger que se activa antes de hacer una inserción de registro en la Tabla Compras, calculando el Importe Total por una compra y el Impuesto al Valor Agregado que corresponda.
CREATE TRIGGER `Tr_Calcular_Importe_IVA`
BEFORE INSERT ON `Compras`
FOR EACH ROW
SET NEW.Total_con_IVA = NEW.Importe_Total * 0.25 + NEW.Importe_Total;

SET SQL_SAFE_UPDATES = 0;

-- DML
-- Register
-- Table: Usuario
INSERT INTO Usuario VALUES 
(NULL, 'Juan Fukuyama', 'DNI','15716873', 'jfuku@mail.com.ar', '1158413322', 'k4578mrY-'),
(NULL, 'Alexander Locke', 'DNI','11714229', 'alexlock@mail.com.ar', '1158315798', '4589KrKp'),
(NULL, 'Georgina Ferrari', 'DNI','30156937', 'ferrarige@mail.com.ar', '118492628', 'MA95jab'),
(NULL, 'Francisco Carusso', 'DNI','33486721', 'francass@mail.com.ar', '115827827', 'Ya-gj9car'),
(NULL, 'Alicia Beck', 'DNI','29363991', 'beck2002@mail.com.ar', '158913252', 'f0l44+-M'),
(NULL, 'Daniel Celi', 'DNI','35723981', 'dceli@mail.com.ar', '153123298', 'ya2m43a23'),
(NULL, 'Esther Gallo', 'DNI','25636921', 'egallo45@mail.com.ar', '152129132', 'jdsdJJ32+'),
(NULL, 'Eduardo Rossi', 'DNI','33873254', 'rossiedu@mail.com.ar', '152229872', 'kanfsf975'),
(NULL, 'Laura Michetti', 'DNI','23753321', 'lauramichetti@mail.com.ar', '153219476', 'red9e9F'),
(NULL, 'Mauricio Lammens', 'DNI','21343172', 'lammens2015@mail.com.ar', '158132472', 'Rae99C_'),
(NULL, 'Ricardo Hernandez', 'DNI','23769251', 'hernandezricardo29@mail.com.ar', '113219673', 'mi5498AAM'),
(NULL, 'Baltazar Smith', 'DNI','25765993', 'smithj@mail.com.ar', '112254391', 'sithRR992A'),
(NULL, 'Maximo Boer', 'DNI','27645593', 'boer54@mail.com.ar', '115431391', 'ACA89hd4'),
(NULL, 'Lujan Arise', 'DNI','348773297', 'larise@mail.com.ar', '152529300', 'moto2501ko');

-- Table: Subcategoria
INSERT INTO Subcategoria VALUES 
(NULL, 'Congelados'),
(NULL, 'Postres'),
(NULL, 'Televisores'),
(NULL, 'Computadoras'),
(NULL, 'Abrigos'),
(NULL, 'Pantalones');

-- Table: Producto
INSERT INTO Producto VALUES 
(NULL, 'Pizza de Muzzarella', 1500.00, 'Alimentos', 1, 'C2384759546'),
(NULL, 'Salmon Noruego', 11000.00, 'Alimentos', 1, 'C3565767767'),
(NULL, 'Arvejas', 500.00, 'Alimentos', 1, 'C3445459983'),
(NULL, 'Torta Rogel', 3500.00, 'Alimentos', 2, 'C1059473962'),
(NULL, 'Flan Tipo Casero', 1000.00, 'Alimentos', 2, 'C6853034853'),
(NULL, 'Smart TV 40 pulgadas', 90000.00, 'Electronica', 3, 'C6843629512'),
(NULL, 'Smart TV 50 pulgadas', 110000.00, 'Electronica', 3, 'C6749460493'),
(NULL, 'Notebook HP', 300000.00, 'Electronica', 4, 'C5453894245'),
(NULL, 'Notebook EP', 250000.00, 'Electronica', 4, 'C8459684521'),
(NULL, 'Campero de cuero', 78000.00,'Indumentaria', 5, 'C5470373093'),
(NULL, 'Parka', 45000.00, 'Indumentaria', 5, 'C5749295021'),
(NULL, 'Jean', 25000.00, 'Indumentaria', 6, 'C5849851277'),
(NULL, 'Pantalon de Corderoy', 20000.00, 'Indumentaria', 6, 'C9583723359'),
(NULL, 'Pantalon Deportivo', 18000.00, 'Indumentaria', 6, 'C2354092641');

-- Table: Proveedor
INSERT INTO Proveedor VALUES 
(NULL, 'Empresa A','158931254', 'www.empresaa.com.ar', 'empresaa@mail.com'),
(NULL, 'Empresa B','153512674', NULL, 'empresab@mail.com'),
(NULL, 'Empresa C','152547492', NULL, 'empresac@mail.com'),
(NULL, 'Empresa D','154324536', 'www.empresad.com.ar', 'empresad@mail.com'),
(NULL, 'Empresa E','157465920', NULL, 'empresae@mail.com'),
(NULL, 'Empresa F','115343847', 'www.empresaf.com.ar', 'empresaf@mail.com'),
(NULL, 'Empresa Alpha','114437583', NULL, 'empresaal@mail.com'),
(NULL, 'Empresa Beta','152348484', 'www.empresabeta.com.ar', 'empresabe@mail.com'),
(NULL, 'Empresa Gamma','112153234', NULL, 'empresaga@mail.com'),
(NULL, 'Empresa Omega','158924131', 'www.empresaomega.com.ar', 'empresaome@mail.com');

-- Table: Proveedor de Producto
INSERT INTO Proveedor_Producto VALUES 
(1, 1, 40),
(1, 2, 40),
(2, 3, 40),
(3, 4, 40),
(4, 5, 40),
(5, 6, 40),
(6, 7, 40),
(6, 8, 40),
(7, 9, 40),
(8, 10, 40),
(9, 11, 40),
(10, 12, 40),
(10, 13, 40),
(10, 14, 40);

-- Table: Ciudad
INSERT INTO Ciudad VALUES 
(NULL, 'Lanus'),
(NULL, 'Rosario'),
(NULL, 'Pilar'),
(NULL, 'Colon');

-- Table: Direccion de Envio
INSERT INTO Direccion_Envio VALUES 
(NULL, 'Buenos Aires', 1, 'Iberlucea', '3200', NULL, NULL, 1625),
(NULL, 'Buenos Aires', 1, '9 de Julio', '1100', '3', 'A', 1820),
(NULL, 'Santa Fe', 2, 'Lisandro de la Torre', '2600', '9', 'C', 2000),
(NULL, 'Buenos Aires', 1, 'Carlos Gardel', '1503', NULL, NULL, 1821),
(NULL, 'Buenos Aires', 1, 'Quintana', '2709', NULL, NULL, 1821),
(NULL, 'Buenos Aires', 1, 'Hipolito Yrigoyen', '11504', '5', 'B', 1823),
(NULL, 'Santa Fe', 2, 'Alberdi', '9874', NULL, NULL, 2001),
(NULL, 'Buenos Aires', 1, 'Belgrano', '1603', NULL, NULL, 1625),
(NULL, 'Buenos Aires', 1, 'San Martin', '1780', '4', 'A', 1625),
(NULL, 'Buenos Aires', 1, 'Las Piedras', '2400', '3', 'B', 1625),
(NULL, 'Buenos Aires', 1, 'Ituzaingo', '1803', '8', 'C', 1823),
(NULL, 'Buenos Aires', 1, 'General Guido', '1940', NULL, NULL, 1821),
(NULL, 'Santa Fe', 2, '17 de Agosto', '2506', NULL, NULL, 7602),
(NULL, 'Santa Fe', 2, 'Junin', '1901', '7', 'C', 2003);

-- Table: Oferta
INSERT INTO Oferta VALUES 
(NULL, 20, '2023-04-19 00:00:01', '2023-05-29 23:59:59', 6),
(NULL, 20, '2023-04-19 00:00:01', '2023-05-29 23:59:59', 7),
(NULL, 20, '2023-04-19 00:00:01', '2023-05-29 23:59:59', 8),
(NULL, 20, '2023-04-19 00:00:01', '2023-05-29 23:59:59', 9);

-- Table: Forma de Pago
INSERT INTO Forma_Pago VALUES 
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 6),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 6),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 6),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Debito', 1),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 3),
(NULL, 'Tarjeta de Credito', 6);

-- Table: Compras
INSERT INTO Compras VALUES 
(NULL, '2023-04-20 17:34:22', 1, 72000.00, NULL, 1, 1),
(NULL, '2023-04-21 17:34:43', 2, 88000.00, NULL, 2, 2),
(NULL, '2023-04-22 17:35:11', 3, 240000.00, NULL, 3, 3),
(NULL, '2023-04-23 17:36:45', 4, 200000.00, NULL, 4, 4),
(NULL, '2023-04-24 17:36:52', 5, 78000.00, NULL, 5, 5),
(NULL, '2023-04-25 17:37:02', 6, 20000.00, NULL, 6, 6),
(NULL, '2023-04-26 17:37:09', 7, 18000.00, NULL, 7, 7),
(NULL, '2023-04-27 17:37:29', 8, 72000.00, NULL, 8, 8),
(NULL, '2023-04-28 17:37:37', 9, 18000.00, NULL, 9, 9),
(NULL, '2023-05-01 17:38:12', 10, 88000.00, NULL, 10, 10),
(NULL, '2023-05-02 17:38:29', 11, 45000.00, NULL, 11, 11),
(NULL, '2023-05-03 17:38:43', 12, 200000.00, NULL, 12, 12),
(NULL, '2023-05-04 17:39:25', 13, 240000.00, NULL, 13, 13),
(NULL, '2023-05-05 17:39:47', 14, 200000.00, NULL, 14, 14),
(NULL, '2023-05-06 17:34:22', 1, 72000.00, NULL, 15, 1),
(NULL, '2023-05-07 17:34:43', 2, 88000.00, NULL, 16, 2),
(NULL, '2023-05-08 17:35:11', 3, 240000.00, NULL, 17, 3),
(NULL, '2023-05-09 17:36:45', 4, 200000.00, NULL, 18, 4),
(NULL, '2023-05-10 17:36:52', 5, 78000.00, NULL, 19, 5),
(NULL, '2023-05-11 17:37:02', 6, 20000.00, NULL, 20, 6),
(NULL, '2023-05-12 17:37:09', 7, 18000.00, NULL, 21, 7),
(NULL, '2023-05-13 17:37:29', 8, 72000.00, NULL, 22, 8),
(NULL, '2023-05-14 17:37:37', 9, 18000.00, NULL, 23, 9),
(NULL, '2023-05-15 17:38:12', 10, 88000.00, NULL, 24, 10),
(NULL, '2023-05-16 17:38:29', 11, 45000.00, NULL, 25, 11),
(NULL, '2023-05-17 17:38:43', 12, 200000.00, NULL, 26, 12),
(NULL, '2023-05-18 17:39:25', 13, 240000.00, NULL, 27, 13),
(NULL, '2023-05-19 17:39:47', 14, 200000.00, NULL, 28, 14);

-- Table: Compras de Producto
INSERT INTO Compras_Producto VALUES 
(1, 6, 90000.00, 1),
(2, 7, 110000.00, 1),
(3, 8, 300000.00, 1),
(4, 9, 250000.00, 1),
(5, 10, 78000.00, 1),
(6, 13, 20000.00, 1),
(7, 14, 18000.00, 1),
(8, 6, 90000.00, 1),
(9, 14, 18000.00, 1),
(10, 7, 110000.00, 1),
(11, 11, 45000.00, 1),
(12, 9, 250000.00, 1),
(13, 8, 300000.00, 1),
(14, 9, 250000.00, 1),
(15, 6, 90000.00, 1),
(16, 7, 110000.00, 1),
(17, 8, 300000.00, 1),
(18, 9, 250000.00, 1),
(19, 10, 78000.00, 1),
(20, 13, 20000.00, 1),
(21, 14, 18000.00, 1),
(22, 6, 90000.00, 1),
(23, 14, 18000.00, 1),
(24, 7, 110000.00, 1),
(25, 11, 45000.00, 1),
(26, 9, 250000.00, 1),
(27, 8, 300000.00, 1),
(28, 9, 250000.00, 1);

-- DCL
-- MySQL
-- Table: MySQL User

USE mysql;
SHOW tables;

SELECT * FROM user;

-- Create User
-- Creación de dos usuarios bajo el dominio localhost.

CREATE USER usuario1@localhost;

CREATE USER coderhouse@localhost;

-- Ambos usuarios no requieren generar password por ello no se utiliza en las sentencias precedentes el IDENTIFIED BY. 

SHOW VARIABLES LIKE 'validate_password%';

-- Establecimiento de permisos sobre Objetos a Usuarios
-- Otorgamiento de permiso de lectura sobre todas las Tablas del Schema e_commerce_model.

GRANT SELECT ON e_commerce_model.* TO usuario1@localhost;

-- Otorgamiento de permiso de lectura, inserción y modificación de datos sobre todas las Tablas del Schema e_commerce_model.

GRANT SELECT, INSERT, UPDATE ON e_commerce_model.* TO coderhouse@localhost;


-- Verificación de permisos establecidos a los Usuarios

SHOW GRANTS FOR usuario1@localhost;

SHOW GRANTS FOR coderhouse@localhost;

-- TCL
USE `e_commerce_model`;
SELECT @@AUTOCOMMIT;
SET AUTOCOMMIT = 0;

-- Rollback and Commit Transactions
START TRANSACTION;
DELETE FROM Oferta
WHERE ID_Oferta = 4;

SELECT * FROM Oferta

-- ROLLBACK;
-- COMMIT;

-- Savepoint
START TRANSACTION;
INSERT INTO Usuario VALUES (NULL, 'Juan Hernandez', 'DNI','15466621', 'juanher@mail.com.ar', '112426172', 'j43Kds66+');
INSERT INTO Usuario VALUES (NULL, 'Jaime Escher', 'DNI','22853684', 'jaimeescher@mail.com.ar', '159427252', 'trtRf95W');
INSERT INTO Usuario VALUES (NULL, 'Alicia Bulrich', 'DNI','39775321', 'abulrich@mail.com.ar', '153346776', 'SJS985');
INSERT INTO Usuario VALUES (NULL, 'Marcelo Alighieri', 'DNI','31356372', 'marceloali5@mail.com.ar', '156672248', 'C_JSH456');
SAVEPOINT Lote_1;
INSERT INTO Usuario VALUES (NULL, 'Benito Hernandez', 'DNI','37659261', 'benitohe9@mail.com.ar', '156734589', 'JDH698');
INSERT INTO Usuario VALUES (NULL, 'Andrea Ianello', 'DNI','35393742', 'iana@mail.com.ar', '112346395', 'DDafA');
INSERT INTO Usuario VALUES (NULL, 'Daniel Picasso', 'DNI','37659643', 'dpicasso23@mail.com.ar', '115916742', 'Aerar4');
INSERT INTO Usuario VALUES (NULL, 'Adriana Richieri', 'DNI','40835267', 'richiadri@mail.com.ar', '116005474', 'qeew67501o');
SAVEPOINT Lote_2;

SELECT * FROM Usuario;

-- ROLLBACK TO Lote_1;
-- COMMIT;