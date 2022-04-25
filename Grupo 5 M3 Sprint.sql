/* sprint evaluacion final mmodulo 3 - Bases de datos */
/* Grupo 5 -  Militza Ortega, Gregory Casanova, Jose Toloza */ 

/* Deben crear un usuario con privilegios para crear, eliminar y modificar tablas, insertar registros.*/
/* ejecutar en -u root -p / Local instance 3306 / Local instance MySQL80 */ 
CREATE DATABASE te_lo_vendo_sprint CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'grupo_cinco'@'localhost' IDENTIFIED BY 'Kr_5s5S9SZhG';
GRANT ALL PRIVILEGES ON te_lo_vendo_sprint.* TO 'grupo_cinco'@'localhost';

/*
Cada proveedor debe informarnos el nombre del representante legal, su nombre corporativo, al menos dos teléfonos de
contacto (y el nombre de quien recibe las llamadas), la categoría de sus productos (solo nos pueden
indicar una categoría) y un correo electrónico para enviar la factura
*/
/* tabla vendors */
CREATE TABLE `te_lo_vendo_sprint`.`vendors` (
  `vend_id` INT NOT NULL AUTO_INCREMENT,
  `agent_name` VARCHAR(50) NULL,
  `corporate_name` VARCHAR(50) NULL,
  `prim_contact_phone` VARCHAR(12) NULL,
  `sec_contact_phone` VARCHAR(12) NULL,
  `prim_contact_name` VARCHAR(40) NULL,
  `sec_contact_name` VARCHAR(40) NULL,
  `prod_category` VARCHAR(40) NULL,
  `billing_email` VARCHAR(25) NULL,
  PRIMARY KEY (`vend_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*
Sabemos que la mayoría de los proveedores son de productos electrónicos. 
Agregue 5 proveedores a la base de datos.
*/
INSERT INTO `te_lo_vendo_sprint`.`vendors`(`agent_name`, `corporate_name`, `prim_contact_phone`, `sec_contact_phone`, `prim_contact_name`, `sec_contact_name`, `prod_category`, `billing_email`)
VALUES('Early Dudeney','Samsung','+56978642589','+56999653525','Olenka Corrigan','Jermain Clewlowe','Productos electrónicos','edudeney0@storify.com'),
('Dalt Curton','Firestone','+56945783215','+56900025964','Mathew Blacksell','Rozamond Aveson','Neumaticos','dcurton3@51.la'),
('Layne Pendock','LG','+56957853245','+56955558697','Izzy Gateshill','Dita Ellit','Productos electrónicos','lpendock6@tinyurl.com'),
('Edin Shutte','HP','+56988251456','+56988645798','Burk Tuckie','Florida Tampion','Productos electrónicos','eshutte9@ow.ly'),
('Conway Annes','LENOVO','+56977584698','+56944575769','Kalli Fuggles','Niel Rickarsey','Productos electrónicos','cannesc@springer.com');


/*
Cada cliente tiene un nombre, apellido, dirección (solo pueden ingresar una).
*/
/* tabla clients */
CREATE TABLE `te_lo_vendo_sprint`.`clients` (
  `cilent_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(20) NULL,
  `last_name` VARCHAR(20) NULL,
  `address` VARCHAR(60) NULL,
  PRIMARY KEY (`cilent_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*
TeLoVendo tiene actualmente muchos clientes, pero nos piden que ingresemos solo 5 para probar la nueva base de datos
*/
INSERT INTO `te_lo_vendo_sprint`.`clients`
(`first_name`,`last_name`,`address`)
VALUES('Nari','Brennans','81526 Everett Terrace'),
('Starla','Lisamore','306 Paget Way'),
('Corey','Schulze','469 Lakeland Point'),
('Al','Horsburgh','1685 Sommers Circle'),
('Guthrie','Rillett','5528 Upham Place');


/* tabla products */
CREATE TABLE `te_lo_vendo_sprint`.`products` (
  `prod_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NULL,
  `price` INT NULL,
  `category` VARCHAR(40) NULL,
  `color` VARCHAR(15) NULL,
  PRIMARY KEY (`prod_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*
- En general, los proveedores venden muchos productos.
- Los productos pueden tener muchos proveedores.
*/
/* tabla inventory */
CREATE TABLE `te_lo_vendo_sprint`.`inventory` (
  `inv_id` INT NOT NULL AUTO_INCREMENT,
  `prod_id` INT NOT NULL,
  `vend_id` INT NOT NULL,
  `stock` INT NULL DEFAULT 0,
  PRIMARY KEY (`inv_id`),  
  CONSTRAINT `inv_prod_fk`
    FOREIGN KEY (`prod_id`)
    REFERENCES `te_lo_vendo_sprint`.`products` (`prod_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `inv_vend_fk`
    FOREIGN KEY (`vend_id`)
    REFERENCES `te_lo_vendo_sprint`.`vendors` (`vend_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

/*
TeLoVendo tiene diferentes productos. Ingrese 10 productos y su respectivo stock
*/
/* productos */
INSERT INTO `te_lo_vendo_sprint`.`products`(`name`,`price`,`category`,`color`)
VALUES('notebook hp gamer',1500000,'Productos electrónicos','Plateado'),
('notebook lenovo core i5',850000,'Productos electrónicos','Negro'),
('Televisor LG 40 pulgadas',300000,'Productos electrónicos','Negro'),
('notebook lenovo gamer',1100000,'Productos electrónicos','Negro'),
('Refrigerador LG',850000,'Productos electrónicos','Plateado'),
('neumatico 185 65 r15 Firestone',20000,'Productos Auto','Negro'),
('Lavadora LG',350000,'Productos electrónicos','Blanco'),
('Lavadora Samsung',300000,'Productos electrónicos','Blanco'),
('Secadora LG',350000,'Productos electrónicos','Plateado'),
('Secadora Samsung',200000,'Productos electrónicos','Blanco');

/* stock */
INSERT INTO `te_lo_vendo_sprint`.`inventory`(`prod_id`,`vend_id`,`stock`)
VALUES(1,4,30),(2,5,40),(3,3,10),(4,5,15),(5,3,4),
(6,2,54),(7,3,5),(8,1,4),(9,3,12),(10,1,8);

/* Luego debemos realizar consultas SQL que indiquen: */
/* - Cuál es la categoría de productos que más se repite. */
SELECT category, COUNT(category) AS total
FROM products
GROUP BY category
ORDER BY total DESC LIMIT 1;

/* - Cuáles son los productos con mayor stock */
SELECT * 
FROM inventory i
INNER JOIN products p
ON i.prod_id = p.prod_id
WHERE i.stock in(SELECT max(i2.stock) FROM inventory i2);

/* - Qué color de producto es más común en nuestra tienda. */
SELECT color AS color_mas_comun, count(color) AS cantidad
FROM products
GROUP BY color
ORDER BY cantidad DESC LIMIT 1;

/* - Cual o cuales son los proveedores con menor stock de productos. */
SELECT cantidades.vend_id, cantidades.corporate_name, min(cantidades.cantidad) cantidad_minima FROM
(SELECT i.vend_id, v.corporate_name, sum(i.stock) AS cantidad
	FROM inventory i
	INNER JOIN vendors v
	ON i.vend_id = v.vend_id
	GROUP BY i.vend_id
	ORDER BY cantidad ASC) cantidades;

/* Por último: - Cambien la categoría de productos más popular por ‘Electrónica y computación’. */
/* para eliminar el error en update que arroja workbench */
SET SQL_SAFE_UPDATES=0;

/* update de tabla products */
UPDATE products
SET category = 'Electrónica y computación'
WHERE prod_id IN(SELECT products.prod_id
					FROM products
					WHERE category = 'Productos electrónicos');