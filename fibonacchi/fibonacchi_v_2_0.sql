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
