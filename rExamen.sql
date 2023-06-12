USE jardineria;

/*1A. Crea un procedimiento almacenado mejores_lugares que devuelva la lista de ciudades, 
regiones y países con más clientes (debe devolver tres listas). (0,5 PTO)*/

DROP PROCEDURE IF EXISTS mejores_lugares;
DELIMITER $$
CREATE PROCEDURE mejores_lugares()
BEGIN
	SELECT ciudad FROM cliente GROUP BY ciudad ORDER BY COUNT(codigo_cliente) DESC LIMIT 1;
	SELECT region FROM cliente GROUP BY region ORDER BY COUNT(codigo_cliente) DESC LIMIT 1;
	SELECT pais FROM cliente GROUP BY pais ORDER BY COUNT(codigo_cliente) DESC LIMIT 1;
END$$

#CALL mejores_lugares()$$

/*1B. Crea un procedimiento almacenado productos_mas_caros que devuelva la lista de los 10 productos 
(todos los datos) que más han cambiado su precio (en términos absolutos). (0,5 PTO)*/
DROP PROCEDURE IF EXISTS productos_mas_caros$$
CREATE PROCEDURE productos_mas_caros()
BEGIN
	SELECT * FROM producto ORDER BY (precio_venta-precio_proveedor) DESC LIMIT 10;
END$$

#CALL productos_mas_caros()$$

/*2A. Crea un procedimiento almacenado ratio_por_oficina que devuelva el código, ciudad, país, región y el 
ratio de jefes por empleado de cada oficina. (El ratio es la división del número total de jefes por el
número total de empleados). (0,5 PTO*/

DROP PROCEDURE IF EXISTS ratio_por_imagen$$ 
CREATE PROCEDURE ratio_por_imagen ()
BEGIN 
	SELECT o.codigo_oficina,o.ciudad,o.pais,o.region,count(e.codigo_jefe)/count(e.codigo_empleado) FROM oficina o INNER JOIN empleado e ON (o.codigo_oficina=e.codigo_oficina) GROUP BY o.codigo_oficina;
END$$ 

#CALL ratio_por_imagen()$$
/*2B. Crea un procedimiento almacenado mejores_proveedores que devuelve la lista 
ordenada con los proveedores que más stock nos suministran. (0,5 PTO)*/

DROP PROCEDURE IF EXISTS mejores_provedores$$
CREATE PROCEDURE mejores_provedores()
BEGIN
	SELECT proveedor,COUNT(cantidad_en_stock) FROM producto GROUP BY proveedor ORDER BY COUNT(cantidad_en_stock) DESC;
END$$

#CALL mejores_provedores()$$

/*3A. Crea un procedimiento almacenado mejor_vendedor que devuelva los datos del empleado (TODOS) 
que más beneficio (el que ha vendido mayor coste) ha generado de cada oficina. (1 PTO)*/
DROP PROCEDURE IF EXISTS mejor_vendedor$$ 
CREATE PROCEDURE mejor_vendedor()
BEGIN
	SELECT mv.* FROM (SELECT e.*,COUNT(c.codigo_cliente) AS ContaClientes FROM empleado e INNER JOIN cliente c ON (e.codigo_empleado=c.codigo_empleado_rep_ventas) GROUP BY e.codigo_empleado) mv GROUP BY mv.codigo_oficina HAVING MAX(mv.ContaClientes); 
END$$

#CALL mejor_vendedor()$$

/*3B. Crea un procedimiento almacenado mejor_producto_por_forma_pago 
que muestre el nombre de producto más vendido por cada forma de pago y la forma de pago (1 PTO)*/
DROP PROCEDURE IF EXISTS mejor_producto_por_forma_pago$$ 
CREATE PROCEDURE mejor_producto_por_forma_pago()
BEGIN 
	SELECT NombreProducto,f_pago FROM (SELECT pr.nombre as NombreProducto,count(pr.nombre),pago.forma_pago as f_pago from producto pr INNER JOIN detalle_pedido dp ON 		      
    (pr.codigo_producto=dp.codigo_producto) INNER JOIN pedido pe ON (dp.codigo_pedido=pe.codigo_pedido) INNER JOIN cliente c
	ON (pe.codigo_cliente=c.codigo_cliente) INNER JOIN pago ON (c.codigo_cliente=pago.codigo_cliente) GROUP BY pr.nombre) pagos_clientes group by f_pago order by count(NombreProducto);
END$$

/*4A. Crea un procedimiento analisis_pedidos que reciba el código de un pedido y devuelva con una variable tipo out
 una cadena siguiendo: (1.5 PTO)
  - En aquellos pedidos entregados que la fecha de entrega no supere los dos días la fecha esperada el pedido 
  se valorará como "Adecuado".
  - En los pedidos rechazados donde la fecha esperada sea mayor a tres días que la fecha de pedido se marcarán 
  como "Analizar", en caso contrario como "Rechazado".
  - EN los pedidos pendientes donde la fecha esperada sea mayor que 5 días de la fecha de pedido se marcarán 
  como "Analizar"
  - Además el procedimiento tendrá otra variable de tipo out llamada error que se pondrá a uno en aquellos
	casos en los que pueda haber un error en los datos. fecha de entrega menor que fecha de pedido, fecha 
	esperada menor que 
  fecha de pedido y fecha de entrega diferente de null en pedidos rechazados o pendientes.*/
  DROP PROCEDURE IF EXISTS analisis_pedidos$$ 
  CREATE PROCEDURE analisis_pedidos(IN v_codigoPedido INT)
  BEGIN 
  		DECLARE v_estadoEntrega VARCHAR(200);
  		DECLARE v_error BOOLEAN DEFAULT 0;
  		DECLARE v_dEntrega INT;
  		DECLARE v_dEsperada INT;
  		DECLARE v_dPedido INT;
  		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error=1;
  		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_error=1;
  		SET v_dEntrega = (SELECT day(pedido.fecha_entrega) FROM pedido WHERE v_codigoPedido=pedido.codigo_pedido);
  		SET v_dEsperada = (SELECT day(pedido.fecha_esperada) FROM pedido WHERE v_codigoPedido=pedido.codigo_pedido);
  		SET v_dPedido = (SELECT day(pedido.fecha_pedido) FROM pedido WHERE v_codigoPedido=pedido.codigo_pedido);
  		IF ((v_dEntrega-v_dPedido)<=2) THEN
  			SET v_estadoEntrega="Adecuado";
  			SELECT v_estadoEntrega;
  		ELSEIF (2<(v_dEntrega-v_dPedido)<=3) THEN
  			SET v_estadoEntrega="Rechazado";
  			SELECT v_estadoEntrega;
  		ELSEIF (v_dEntrega-v_dPedido>3) THEN
  			SET v_estadoEntrega="Analizar";
  			SELECT v_estadoEntrega;
  		ELSEIF (v_dEntrega-v_dPedido>=5) THEN
  			SET v_estadoEntrega="Analizar";
  			SELECT v_estadoEntrega;
  		ELSEIF ((pedido.fecha_entrega<pedido.fecha_pedido) OR (pedido.fecha_esperada<pedido.fecha_pedido) 
		OR ((pedido.fecha_entrega IS NOT NULL) AND pedido.estado IN ("Pendiente","Rechazado"))) THEN
  			SET v_error=1;
  		ELSEIF (v_codigoPedido NOT IN (SELECT pedido.codigo_pedido FROM pedido)) THEN SET v_error=1;
  		END IF;
  END$$
  
  #CALL analisis_pedidos(1)$$
  
  /*4B. Crea una función coche_empresa que recibe el id de un empleado y en función de su puesto devuelve la 
  cadena: "Mercedes" para el director general, "BMW/AUDI" para los subdirectores, "Otro" para representante 
  de ventas y "Ninguno" en cualquier otro caso. (1.5 PTO)*/
DROP FUNCTION IF EXISTS coche_empresa$$ 
CREATE FUNCTION coche_empresa(v_idEmp int) RETURNS varchar(50)
BEGIN 
		IF (v_idEmp in (SELECT empleado.codigo_empleado FROM empleado WHERE empleado.puesto like '%director general%')) THEN	
	    	RETURN "Mercedes";
	   ELSEIF (v_idEmp in (SELECT empleado.codigo_empleado FROM empleado WHERE empleado.puesto like '%subdirector%')) THEN	
	    	RETURN "BMW/AUDI";
	   ELSEIF (v_idEmp in (SELECT empleado.codigo_empleado FROM empleado WHERE empleado.puesto like '%representante ventas%')) THEN	
	    	RETURN "Otro";
	   ELSE 	
	    	RETURN "Ninguno";
	   END IF;
END$$ 

#SELECT coche_empresa(1)$$

/*5A. Crea una función interes_compuesto que reciba un salario inicial, un intervalo de tiempo como un entero y 
una tasa de interés. El procedimiento devolverá el salario final después de los incrementos. (1.5 PTO)
*/

DROP FUNCTION IF EXISTS interes_compuesto$$ 
CREATE FUNCTION interes_compuesto(v_salarioInicial float,v_intervaloTiempo INT,v_tasaInteres float) RETURNS float
BEGIN
	RETURN v_salarioInicial*POW((1+v_tasaInteres),v_intervaloTiempo);
END$$

#SELECT interes_compuesto(1000.00,2,1.2)$$

/*5B. Crea una función fibonacci que reciba un número y devuelva el número correspondiente en la serie de 
fibonacci. 
La serie de fibonacci es aquella en la que cada elemento se calcula como la suma de los dos.*/
DROP FUNCTION IF EXISTS fibonacchi$$ 
CREATE FUNCTION fibonacchi(numero int) RETURNS int
BEGIN
	RETURN (POW((1+SQRT(5))/2,numero)-POW((1-SQRT(5))/2,numero))/(SQRT(5));
END$$

DROP FUNCTION IF EXISTS fibonacchi$$
CREATE FUNCTION fibonacchi(numero INT) RETURNS INT
BEGIN
	DECLARE a0 INT DEFAULT 0;
	DECLARE a1 INT DEFAULT 1;
	DECLARE a2 INT;
	DECLARE contador INT DEFAULT 0;
	SET a2=a0+a1;
	IF numero=0 THEN RETURN a0;
	ELSEIF numero=1 THEN RETURN a1;
	ELSEIF numero=2 THEN RETURN a2;
	ELSE
		WHILE (contador<=numero-3) DO
			SET contador=contador+1;
			SET a1=a2;
			SET a0=a1;
			SET a2=a0+a1;
			/*IF (contador=numero-3) THEN 
				RETURN a2;
			END IF;*/
		END WHILE;
		RETURN a2;
	END IF; 
END$$
SELECT fibonacchi(4)$$

/*6A. Crea un procedimiento almacenado calculo_iva que calcule el nuevo campo precio_con_iva para la tabla
 producto. El valor del IVA será del 4% para la gama Herramientas, del 10% para herbaceas y frutales
 y del 21% para el resto. Debes cambiar el nombre del campo precio_venta a precio_sin_iva. (3 PTO)*/
 #ALTER TABLE producto ADD OR REPLACE COLUMN precio_con_iva FLOAT;
 DROP PROCEDURE IF EXISTS calculo_iva$$ 
 CREATE PROCEDURE calculo_iva()
 BEGIN
	DECLARE v_precioIVA FLOAT;
	DECLARE v_error BOOLEAN DEFAULT 0;
	DECLARE c_precio CURSOR FOR SELECT precio_venta FROM producto;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_error=1;
	OPEN c_precio;
	WHILE (v_error=0) DO
		FETCH c_precio INTO v_precioIVA;
		IF (v_precioIVA IN (SELECT precio_venta FROM producto WHERE gama LIKE '%Herramientas%')) THEN
			SELECT v_precioIVA*1.04;
		ELSEIF (v_precioIVA IN (SELECT precio_venta FROM producto WHERE gama LIKE '%Herbaceas%')) THEN
			SELECT v_precioIVA*1.1;
		ELSEIF (v_precioIVA IN (SELECT precio_venta FROM producto WHERE gama LIKE '%Frutales%')) THEN
			SELECT v_precioIVA*1.1;
		ELSE 
			SELECT v_precioIVA*1.21;
		END IF;
	END WHILE;
	CLOSE c_precio;
 END$$ 
 
 /*6B. Crea un procedimiento almacenado resumen_pedidos que recibe el id de un cliente y muestre 
 por pantalla todos los pedidos que ha realizado con todos sus detalles de pedido. Al finalizar 
 deberá mostrar una fila con el total gastado y la media de gasto mensual. (3 PTO)*/
 
 DROP PROCEDURE IF EXISTS resumen_pedidos$$
 CREATE PROCEDURE resumen_pedidos()
 BEGIN
 	DECLARE v_idCliente INT;
 	DECLARE v_error BOOLEAN DEFAULT 0;
	DECLARE c_idClientes CURSOR FOR SELECT codigo_cliente FROM cliente;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_error=1;
	OPEN c_idClientes;
	WHILE (v_error=0) DO
		FETCH c_idClientes INTO v_idCliente;
		SELECT pedido.`*`,detalle_pedido.`*` FROM pedido INNER JOIN detalle_pedido ON (pedido.codigo_pedido=detalle_pedido.codigo_pedido) WHERE pedido.codigo_cliente=v_idCliente;
	END WHILE;
	CLOSE c_idClientes;
 END$$

 #CALL calculo_iva()$$
 
 /*7A. Crea un trigger check_puesto_empleado que compruebe que el puesto no es nulo 
 en las actualizaciones. En caso de ser así, deberá insertarse el valor "Por determinar". (2 PTO)*/
 DROP TRIGGER IF EXISTS check_puesto_empleado$$
 CREATE TRIGGER check_puesto_empleado BEFORE UPDATE ON empleado FOR EACH ROW 
 BEGIN
 	IF (old.puesto IS NULL) THEN SET new.puesto='Por determinar';
    END IF;
 END$$
 
 /*7B. Crea un trigger check_fechas que cuando se actualice un pedido compruebe que las fechas de entrega y
  esperada son superiores a la fecha de pedido y en caso contrario deberá enviar un error de tipo 45001 (2 PTO)*/
DROP TRIGGER IF EXISTS check_fechas$$
CREATE TRIGGER check_fechas AFTER UPDATE ON pedido FOR EACH ROW
BEGIN 
	IF (new.fecha_esperada<pedido.fecha_pedido) AND (new.fecha_entrega<pedido.fecha_pedido) THEN SIGNAL SQLSTATE '45001';
    END IF;
END$$