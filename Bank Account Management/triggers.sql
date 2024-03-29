CREATE OR REPLACE TRIGGER TRIG
BEFORE INSERT OR DELETE OR UPDATE ON BANK
FOR EACH ROW
ENABLE
DECLARE
TT TIMESTAMP; 
TransType CHAR;
BEGIN
SELECT SYSTIMESTAMP INTO TT FROM DUAL;
IF INSERTING THEN
	INSERT INTO Audit_Table VALUES (:NEW.Account_Number,TT,'I');
ELSIF UPDATING THEN 
	INSERT INTO Audit_Table VALUES (:OLD.Account_Number,TT,'U');
ELSIF DELETING THEN
	INSERT INTO Audit_Table VALUES (:OLD.Account_Number,TT,'D');
END IF;
END TRIG;
/