CREATE OR REPLACE PACKAGE Bank_Transaction IS
	PROCEDURE NEW_ACCOUNT(Accn BANK.Account_Number%TYPE, Bname BANK.Bank_Name%TYPE, Amt BANK.Amount%TYPE);
	PROCEDURE Account_Transaction(Accn BANK.Account_Number%TYPE, TransAmt BANK.Amount%TYPE, TransType Audit_Table.Transaction_type%TYPE);
	PROCEDURE Close_Account(Accn BANK.Account_Number%TYPE);
END Bank_Transaction;
/