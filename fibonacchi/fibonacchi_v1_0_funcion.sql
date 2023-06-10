DELIMITER $$
DROP FUNCTION IF EXISTS fibonacchi$$
CREATE FUNCTION fibonacchi(n INT) RETURNS INT
BEGIN
	DECLARE a INT DEFAULT 0;
    DECLARE b INT DEFAULT 1;
    DECLARE c INT;
    DECLARE contador INT DEFAULT 0;
    DECLARE cAux INT DEFAULT 3;
    SET c=b+a;
    IF (n=0) THEN
    	return a;
    ELSEIF (n=1) THEN
    	return b;
    ELSEIF (n=2) THEN
    	return c;
    ELSE
    	WHILE (contador<=n) DO
        	IF (contador<n) THEN
            	SET c=fibonacchi(cAux-1)+fibonacchi(cAux-2);
                SET fibonacchi(cAux)=c;
                SET cAux=cAux+1;
                SET contador=contador+1;
            ELSE
            	return c;
            END IF;
        END WHILE;
    END IF;
END$$