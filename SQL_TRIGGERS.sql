

DROP TRIGGER IF EXISTS TG_UPD_ENTRADAS;
DELIMITER //
CREATE TRIGGER TG_UPD_ENTRADAS AFTER INSERT ON history
FOR EACH ROW
BEGIN
	
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE v_num_apto INT;
    DECLARE cur CURSOR FOR SELECT num_apto FROM history WHERE Act='Entrada' AND RowID = NEW.RowID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
        ins_loop: LOOP
            FETCH cur INTO v_num_apto;
            IF done THEN
                LEAVE ins_loop;
            END IF;
            UPDATE rfid.apto
				JOIN  rfid.users ON users.num_apto = apto.num_apto
				JOIN rfid.history ON history.UID = users.UID 
				SET apto.VagasDisp = apto.VagasDisp -1	
				WHERE users.num_apto = apto.num_apto
				AND apto.num_apto = v_num_apto
				AND apto.VagasDisp BETWEEN 1 AND apto.TotalVagas;
        END LOOP;            
    CLOSE cur;
END; //
DELIMITER ;


---------------------------------

DROP TRIGGER IF EXISTS TG_UPD_SAIDAS;
DELIMITER //
CREATE TRIGGER TG_UPD_SAIDAS AFTER INSERT ON history
FOR EACH ROW
BEGIN
	
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE v_num_apto INT;
    DECLARE cur CURSOR FOR SELECT num_apto FROM history WHERE Act='Saida' AND RowID = NEW.RowID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
        ins_loop: LOOP
            FETCH cur INTO v_num_apto;
            IF done THEN
                LEAVE ins_loop;
            END IF;
            	UPDATE rfid.apto 
					JOIN  rfid.users 
					ON users.num_apto = apto.num_apto 
					SET apto.VagasDisp = apto.VagasDisp +1	
					WHERE users.num_apto = apto.num_apto 
					AND apto.VagasDisp >= 0 
					AND apto.VagasDisp < apto.TotalVagas
					AND apto.num_apto = v_num_apto;					
        END LOOP;
    CLOSE cur;    
END; //
DELIMITER ;
---------------------------------------------


		UPDATE apto APT
		JOIN  users USR ON USR.num_apto = APT.num_apto 
		SET APT.VagasDisp = VagasDisp -1	
		WHERE USR.num_apto = APT.num_apto 
		AND APT.VagasDisp BETWEEN 1 AND APT.TotalVagas
		AND USR.UID = '0074907C';
		COMMIT;
		
		UPDATE rfid.apto
		JOIN  rfid.users ON users.num_apto = apto.num_apto
		JOIN rfid.history ON history.UID = users.UID 
		SET apto.VagasDisp = VagasDisp -1	
		WHERE users.num_apto = apto.num_apto 
		AND apto.VagasDisp BETWEEN 1 AND apto.TotalVagas
		AND users.UID = '0074907C';
		
		COMMIT;
		

		UPDATE rfid.apto 
		JOIN  rfid.users 
		ON users.num_apto = apto.num_apto 
		SET apto.VagasDisp = apto.VagasDisp +1	
		WHERE users.num_apto = apto.num_apto 
		AND apto.VagasDisp >= 0 
		AND apto.VagasDisp < apto.TotalVagas
		AND users.UID = '0074907C' 
----------------------------		
UPDATE apto SET VagasDisp = VagasDisp-1 WHERE(SELECT users.num_apto FROM users WHERE users.num_apto = apto.num_apto AND apto.VagasDisp BETWEEN 1 AND apto.TotalVagas AND users.UID = '0074907C')

UPDATE apto SET VagasDisp = VagasDisp -1 WHERE(SELECT users.num_apto FROM users WHERE users.num_apto = apto.num_apto AND apto.VagasDisp BETWEEN 1 AND apto.TotalVagas AND users.UID= '0074907C')
---------------------------------



DELIMITER //
CREATE PROCEDURE p2()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE x  INT(11);
  DECLARE cur1 CURSOR FOR SELECT apto.num_apto FROM rfid.apto;   
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1; 
  read_loop:LOOP
    FETCH cur1 INTO x;  
	 IF done THEN
      LEAVE read_loop;
    END IF;  
    IF 1 = 1 THEN
    	UPDATE rfid.apto	
		SET apto.VagasDisp = VagasDisp -1
		WHERE  apto.num_apto = x
		AND apto.VagasDisp BETWEEN 1 
		AND apto.TotalVagas;
     END IF;
  END LOOP;
  CLOSE cur1;  
END; //
DELIMITER ;

CALL p2;
CALL rfid.p2(x=101);

