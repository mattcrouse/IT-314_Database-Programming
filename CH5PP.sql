SET SERVEROUTPUT ON SIZE 3000

/*PROBLEM 5*/
create or replace PROCEDURE STATUS_SHIP_SP
    (id_status IN OUT BB_BASKETSTATUS.idstatus%TYPE)
IS
    basket_num BB_BASKETSTATUS.idbasket%TYPE := 3;
    basket_stage BB_BASKETSTATUS.idstage%TYPE := 3;
    date_shipped BB_BASKETSTATUS.dtstage%TYPE := '20-FEB-12';
    shipper BB_BASKETSTATUS.shipper%TYPE := 'UPS';
    tracking_num BB_BASKETSTATUS.shippingnum%TYPE := 'ZW2384YXK4957';
BEGIN
    id_status := BB_STATUS_SEQ.NEXTVAL;
    INSERT INTO BB_BASKETSTATUS
        (idstatus, idbasket, idstage, dtstage, notes, shipper, shippingnum)
        VALUES(id_status, basket_num, basket_stage, date_shipped, NULL, shipper,
        tracking_num);
    COMMIT;
END;

/*PROBLEM 6*/
create or replace PROCEDURE STATUS_SP
    (id_basket IN OUT BB_BASKETSTATUS.idbasket%TYPE)
IS
   date_shipped BB_BASKETSTATUS.dtstage%TYPE;
   basket_stage BB_BASKETSTATUS.idstage%TYPE;
BEGIN
    SELECT dtstage, idstage
        INTO date_shipped, basket_stage
        FROM BB_BASKETSTATUS
        WHERE idbasket = id_basket
        ORDER BY dtstage DESC
        fetch first 1 row only;
    IF basket_stage = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Submitted and received');
    ELSIF basket_stage = 2 THEN
        DBMS_OUTPUT.PUT_LINE('Confirmed, processed, sent to shipping');
    ELSIF basket_stage = 3 THEN
        DBMS_OUTPUT.PUT_LINE('Shipped');
    ELSIF basket_stage = 4 THEN
        DBMS_OUTPUT.PUT_LINE('Canceled');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Back-ordered');
    END IF;
    DBMS_OUTPUT.PUT_LINE(date_shipped);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO STATUS AVAILABLE');
END;

/*PROBLEM 7*/
create or replace PROCEDURE PROMO_SHIP_SP
IS
    date_created BB_BASKET.dtcreated%TYPE;
    shopper_id BB_BASKET.idshopper%TYPE;
    rec_promo BB_BASKET%ROWTYPE;
    CURSOR cur_promo IS
        SELECT DISTINCT idshopper
        FROM BB_BASKET
        WHERE dtcreated > '15-FEB-12';
BEGIN
    FOR rec_promo IN cur_promo LOOP   
        INSERT INTO BB_PROMOLIST
        VALUES(rec_promo.idshopper, 'APR', '12', 1, 'N');
        EXIT WHEN cur_promo%NOTFOUND;
    END LOOP;
END;  

/*PROBLEM 8*/
create or replace PROCEDURE BASKET_ADD_SP(
    idbi OUT BB_BASKETITEM.idbasketitem%TYPE,
    idproduct IN OUT BB_BASKETITEM.idproduct%TYPE,
    idbasket IN OUT BB_BASKETITEM.idbasket%TYPE,
    price IN OUT BB_BASKETITEM.price%TYPE,
    quantity IN OUT BB_BASKETITEM.quantity%TYPE,
    sco IN OUT BB_BASKETITEM.option1%TYPE,
    fco IN OUT BB_BASKETITEM.option2%TYPE)
IS 
BEGIN
    idbi := BB_IDBASKETITEM_SEQ.NEXTVAL;
    INSERT INTO BB_BASKETITEM
    VALUES(idbi, idproduct, price, quantity, idbasket, sco, fco);    
END;

/*PROBLEM 9*/
create or replace PROCEDURE MEMBER_CK_SP(
    usern IN BB_SHOPPER.username%TYPE,
    pass IN OUT VARCHAR2,
    cookieout OUT VARCHAR2,
    p_check OUT VARCHAR2)
IS
    flname VARCHAR2(100);
    ucookie NUMBER;
BEGIN
    SELECT firstname||' '||lastname, cookie
        INTO flname, ucookie 
        FROM BB_SHOPPER
        WHERE username = usern AND password = pass;
        DBMS_OUTPUT.PUT_LINE(flname||' COOKIE: '||ucookie);
        pass := flname;
        cookieout := ucookie;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_check := 'INVALID';
        DBMS_OUTPUT.PUT_LINE(p_check);
END;










