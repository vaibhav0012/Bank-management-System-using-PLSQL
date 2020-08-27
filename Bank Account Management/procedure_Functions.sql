CREATE OR REPLACE PACKAGE BODY Bank_Transaction IS
	FUNCTION Return_boolean(Accn BANK.Account_Number%TYPE) RETURN BOOLEAN
	IS
	COU NUMBER;
	BEGIN
		SELECT COUNT(*) INTO COU FROM BANK WHERE Account_Number = Accn;
		IF COU > 0 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END Return_boolean;

	PROCEDURE NEW_ACCOUNT(Accn BANK.Account_Number%TYPE, Bname BANK.Bank_Name%TYPE, Amt BANK.Amount%TYPE)
	IS
	EXP1 EXCEPTION;
	BEGIN
		IF Return_boolean(Accn) = TRUE THEN
			RAISE EXP1;
		ELSE
			INSERT INTO BANK(Account_Number,Bank_Name,Amount) VALUES(Accn,Bname,Amt);
			DBMS_OUTPUT.PUT_LINE('Account added withh Account Number: '||Accn);
		END IF;
	EXCEPTION
		WHEN EXP1 THEN
			DBMS_OUTPUT.PUT_LINE('Account Already Exists');
	END NEW_ACCOUNT;
	
	
	PROCEDURE ACCOUNT_TRANSACTION(Accn BANK.Account_Number%TYPE, TransAmt BANK.Amount%TYPE, TransType Audit_Table.Transaction_type%TYPE)
	IS
	Amt BANK.Amount%TYPE;
	Tamt BANK.Amount%TYPE;
	EXP1 EXCEPTION;
	EXP2 EXCEPTION;
	EXP3 EXCEPTION;
	BEGIN
		IF Return_boolean(Accn) = TRUE THEN
			SELECT Amount INTO Amt FROM BANK WHERE Account_Number = Accn;
			IF TransType = 'W' THEN
				IF Amt - TransAmt < 5000 THEN
					RAISE EXP1;
				ELSE
					SELECT Amt-TransAmt INTO Tamt FROM BANK WHERE Account_Number = Accn;
					UPDATE BANK SET Amount = Amount-TransAmt WHERE Account_Number = Accn;
					DBMS_OUTPUT.PUT_LINE(TransAmt||' withdrawn from account number: '||Accn);
					DBMS_OUTPUT.PUT_LINE('Remaining Balance = '||Tamt);
				END IF;
			ELSIF TransType = 'D' THEN
				SELECT Amt+TransAmt INTO Tamt FROM BANK WHERE Account_Number = Accn;
				UPDATE BANK SET Amount = Amount+TransAmt WHERE Account_Number = Accn;
				DBMS_OUTPUT.PUT_LINE(TransAmt||' Deposited into account number: '||Accn);
				DBMS_OUTPUT.PUT_LINE('Remaining Balance = '||Tamt);
			ELSE
				RAISE EXP2;
			END IF;
		ELSE
			RAISE EXP3;
		END IF;
	EXCEPTION
		WHEN EXP1 THEN
			DBMS_OUTPUT.PUT_LINE('Cant Withdraw Minimum Bank Limit is Rs 5000');
		WHEN EXP2 THEN
			DBMS_OUTPUT.PUT_LINE('Invalid Operation');
		WHEN EXP3 THEN
			DBMS_OUTPUT.PUT_LINE('Invalid Account Number');
	END ACCOUNT_TRANSACTION;

	PROCEDURE Close_Account(Accn BANK.Account_Number%TYPE)
	IS
	EXP1 EXCEPTION;
	BEGIN
		IF Return_boolean(Accn) = TRUE THEN
			DELETE FROM BANK WHERE Account_Number = Accn;
			DBMS_OUTPUT.PUT_LINE('Account deleted for account number: '||Accn);
		ELSE
			RAISE EXP1;
		END IF;
	EXCEPTION
		WHEN EXP1 THEN
			DBMS_OUTPUT.PUT_LINE('Invalid Account Number');
	END Close_Account;

END Bank_Transaction;
/
