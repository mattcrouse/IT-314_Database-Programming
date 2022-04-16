SET SERVEROUTPUT ON SIZE 3000

/*PROBLEM 10*/-----------------------------------------
create or replace PROCEDURE DDPROJ_SP(
    projid IN DD_PROJECT.idproj%TYPE,
    rec_proj OUT DD_PROJECT%ROWTYPE)
IS
BEGIN
    SELECT * INTO rec_proj
    FROM DD_PROJECT
    WHERE idproj = projid;
END;
--
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

/*PROBLEM 11*/------------------------------------------
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
--
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

/*PROBLEM 12*/
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
