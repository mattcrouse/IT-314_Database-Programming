SET SERVEROUTPUT ON SIZE 3000

/*PROBLEM 9
Create a block to retrieve and display pledge and payment information for a specific donor. For
each pledge payment from the donor, display the pledge ID, pledge amount, number of monthly
payments, payment date, and payment amount. The list should be sorted by pledge ID and then
by payment date. For the first payment made for each pledge, display “first payment” on that
output row.*/
DECLARE
    CURSOR cur_pledge IS
        SELECT pl.idpledge, pl.pledgeamt, pl.paymonths, pa.paydate, pa.payamt
        FROM DD_PLEDGE pl JOIN DD_PAYMENT pa ON pl.idpledge = pa.idpledge
        WHERE iddonor = 302
        ORDER BY pa.paydate;
    TYPE type_pledge IS RECORD(
        idpledge DD_PLEDGE.idpledge%TYPE,
        pledgeamt DD_PLEDGE.pledgeamt%TYPE,
        paymonths DD_PLEDGE.paymonths%TYPE,
        paydate DD_PAYMENT.paydate%TYPE,
        payamt DD_PAYMENT.payamt%TYPE);
    rec_pledge type_pledge;
    lv_first NUMBER := 0;
BEGIN
    OPEN cur_pledge;
    LOOP
        FETCH cur_pledge INTO rec_pledge;
            EXIT WHEN cur_pledge%NOTFOUND;
            IF lv_first = 0 THEN 
                DBMS_OUTPUT.PUT_LINE('FIRST PAYMENT! '||'PLEDGE ID: '||rec_pledge.idpledge||
                ' PLEDGE AMOUNT: '||rec_pledge.pledgeamt||' PAY MONTHS: '||
                rec_pledge.paymonths||' PAY DATE: '||rec_pledge.paydate||
                ' PAY AMOUNT: '||rec_pledge.payamt);
                lv_first := 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('PLEDGE ID: '||rec_pledge.idpledge||
                ' PLEDGE AMOUNT: '||rec_pledge.pledgeamt||' PAY MONTHS: '||
                rec_pledge.paymonths||' PAY DATE: '||rec_pledge.paydate||
                ' PAY AMOUNT: '||rec_pledge.payamt);
            END IF;
    END LOOP;
    CLOSE cur_pledge;
END;     

/*PROBLEM 10
Redo Assignment 9, but use a different cursor form to perform the same task.*/
DECLARE
    CURSOR cur_pledge IS
        SELECT pl.idpledge, pl.pledgeamt, pl.paymonths, pa.paydate, pa.payamt
        FROM DD_PLEDGE pl JOIN DD_PAYMENT pa ON pl.idpledge = pa.idpledge
        WHERE iddonor = 302
        ORDER BY pa.paydate;
    TYPE type_pledge IS RECORD(
        idpledge DD_PLEDGE.idpledge%TYPE,
        pledgeamt DD_PLEDGE.pledgeamt%TYPE,
        paymonths DD_PLEDGE.paymonths%TYPE,
        paydate DD_PAYMENT.paydate%TYPE,
        payamt DD_PAYMENT.payamt%TYPE);
    rec_pledge type_pledge;
    lv_first NUMBER := 0; 
BEGIN
    FOR rec_pledge IN cur_pledge LOOP
            IF lv_first = 0 THEN 
                DBMS_OUTPUT.PUT_LINE('FIRST PAYMENT! '||'PLEDGE ID: '||rec_pledge.idpledge||
                ' PLEDGE AMOUNT: '||rec_pledge.pledgeamt||' PAY MONTHS: '||
                rec_pledge.paymonths||' PAY DATE: '||rec_pledge.paydate||
                ' PAY AMOUNT: '||rec_pledge.payamt);
                lv_first := 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('PLEDGE ID: '||rec_pledge.idpledge||
                ' PLEDGE AMOUNT: '||rec_pledge.pledgeamt||' PAY MONTHS: '||
                rec_pledge.paymonths||' PAY DATE: '||rec_pledge.paydate||
                ' PAY AMOUNT: '||rec_pledge.payamt);
            END IF;
    END LOOP;
END; 
