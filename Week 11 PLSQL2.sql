SET SERVEROUTPUT ON SIZE 3000

/*PROBLEM 10
Create a procedure named DDPROJ_SP that retrieves project information for a specific project based on a project ID. 
The procedure should have two parameters: one to accept a project ID value and another to return all data for the specified project.
Use a record variable to have the procedure return all database column values for the selected project. Test the procedure with an anonymous block.*/

create or replace PROCEDURE DDPROJ_SP(
    projid IN DD_PROJECT.idproj%TYPE,
    rec_proj OUT DD_PROJECT%ROWTYPE)
IS
BEGIN
    SELECT * INTO rec_proj
    FROM DD_PROJECT
    WHERE idproj = projid;
END;

--TESTING THE PROCEDURE

DECLARE
    rec_proj DD_PROJECT%ROWTYPE; 
BEGIN
DDPROJ_SP(500, rec_proj);
DBMS_OUTPUT.PUT_LINE(rec_proj.idproj);
DBMS_OUTPUT.PUT_LINE(rec_proj.projname);
DBMS_OUTPUT.PUT_LINE(rec_proj.projstartdate);
DBMS_OUTPUT.PUT_LINE(rec_proj.projenddate);
DBMS_OUTPUT.PUT_LINE(rec_proj.projfundgoal);
DBMS_OUTPUT.PUT_LINE(rec_proj.projcoord);
END;

/*PROBLEM 11
Create a procedure named DDPAY_SP that identifies whether a donor currently has an active pledge with monthly payments.
A donor ID is the input to the procedure. Using the donor ID, the procedure needs to determine whether the donor has any currently active pledges 
based on the status field and is on a monthly payment plan. If so, the procedure is to return the Boolean value TRUE. 
Otherwise, the value FALSE should be returned. Test the procedure with an anonymous block.*/

create or replace PROCEDURE DDPAY_SP(
    donorid IN DD_PLEDGE.iddonor%TYPE,
    active OUT BOOLEAN)
IS
    rec_pledge DD_PLEDGE%ROWTYPE;
    status NUMBER;
    CURSOR cur_pledge IS
        SELECT DISTINCT idstatus
        INTO status
        FROM DD_PLEDGE
        WHERE iddonor = donorid;
BEGIN
    FOR rec_pledge IN cur_pledge LOOP
        IF status = 10 THEN
            active := TRUE;
        ELSE
            active := FALSE;
        END IF;
    END LOOP;
END;

--TESTING THE PROCEDURE

DECLARE 
    active BOOLEAN;
BEGIN
    DDPAY_SP(304, active);
    
    IF active = TRUE THEN
        DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FALSE');
   END IF;
END;       

/*PROBLEM 12
Create a procedure named DDCKPAY_SP that confirms whether a monthly pledge payment is the correct amount. 
The procedure needs to accept two values as input: a payment amount and a pledge ID.
Based on these inputs, the procedure should confirm that the payment is the correct monthly increment amount, based on pledge data in the database.
If it isn’t, a custom Oracle error using error number 20050 and the message “Incorrect payment amount - planned payment = ??” should be raised.
The ?? should be replaced by the correct payment amount. The database query in25 the procedure should be formulated so that no rows are returned if the pledge
isn’t on a monthly payment plan or the pledge isn’t found. If the query returns no rows, the procedure should display the message “No payment information.” 
Test the procedure with the pledge ID 104 and the payment amount $25. Then test with the same pledge ID but the payment amount $20. 
Finally, test the procedure with a pledge ID for a pledge that doesn’t have monthly payments associated with it.*/

create or replace PROCEDURE DDCKPAY_SP(
    payamt IN DD_PLEDGE.pledgeamt%TYPE,
    pledgeid IN DD_PLEDGE.idpledge%TYPE)
IS
    correct_pledge NUMBER;
    pledge_months NUMBER;
    NO_MONTHS EXCEPTION;
BEGIN
    SELECT pledgeamt, paymonths
        INTO correct_pledge, pledge_months
        FROM DD_PLEDGE
        WHERE idpledge = pledgeid;
    IF pledge_months = 0 THEN
        RAISE NO_MONTHS;
    ELSIF payamt = correct_pledge/pledge_months THEN
        DBMS_OUTPUT.PUT_LINE('CORRECT PAYMENT');
    ELSE
        RAISE_APPLICATION_ERROR(
            -20050, 'INCORRECT PAYMENT AMOUNT - PLANNED PAYMENT = '
            ||correct_pledge/pledge_months);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO PAYMENT INFORMATION');
    WHEN NO_MONTHS THEN
        DBMS_OUTPUT.PUT_LINE('NO PAYMENT INFORMATION');
END;
