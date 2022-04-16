SET SERVEROUTPUT ON SIZE 3000

/*PROBLEM 5
Create a procedure named STATUS_SHIP_SP that allows an employee in the Shipping
Department to update an order status to add shipping information. The BB_BASKETSTATUS
table lists events for each order so that a shopper can see the current status, date, and
comments as each stage of the order process is finished. The IDSTAGE column of the
BB_BASKETSTATUS table identifies each stage; the value 3 in this column indicates that an
order has been shipped.
The procedure should allow adding a row with an IDSTAGE of 3, date shipped, tracking
number, and shipper. The BB_STATUS_SEQ sequence is used to provide a value for the primary key column. Test the procedure with the following information:
Basket # = 3
Date shipped = 20-FEB-12
Shipper = UPS
Tracking # = ZW2384YXK4957*/

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

/*PROBLEM 6
Create a procedure that returns the most recent order status information for a specified basket. 
This procedure should determine the most recent ordering-stage entry in the BB_BASKETSTATUS table and return the data. 
Use an IF or CASE clause to return a stage description instead of an IDSTAGE number, which means little to shoppers. 
The IDSTAGE column of the BB_BASKETSTATUS table identifies each stage as follows:
• 1—Submitted and received
• 2—Confirmed, processed, sent to shipping
• 3—Shipped
• 4—Canceled
• 5—Back-ordered
The procedure should accept a basket ID number and return the most recent status
description and date the status was recorded. If no status is available for the specified basket
ID, return a message stating that no status is available. Name the procedure STATUS_SP. Test
the procedure twice with the basket ID 4 and then 6.*/

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

/*PROBLEM 7
Brewbean’s wants to offer an incentive of free shipping to customers who haven’t returned to the site since a specified date. 
Create a procedure named PROMO_SHIP_SP that determines who these customers are and then updates the BB_PROMOLIST table accordingly. 
The procedure uses the following information:
• Date cutoff—Any customers who haven’t shopped on the site since this date
should be included as incentive participants. Use the basket creation date to
reflect shopper activity dates.
• Month—A three-character month (such as APR) should be added to the promotion
table to indicate which month free shipping is effective.
• Year—A four-digit year indicates the year the promotion is effective.
• promo_flag—1 represents free shipping.
The BB_PROMOLIST table also has a USED column, which contains the default value N
and is updated to Y when the shopper uses the promotion. Test the procedure with the cutoff
date 15-FEB-12. Assign free shipping for the month APR and the year 2012.*/

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

/*PROBLEM 8
As a shopper selects products on the Brewbean’s site, a procedure is needed to add a newly selected item to the current shopper’s basket. 
Create a procedure named BASKET_ADD_SP that accepts a product ID, basket ID, price, quantity, size code option (1 or 2), and form code option (3 or 4)
and uses this information to add a new item to the BB_BASKETITEM table. The table’s PRIMARY KEY column is generated by BB_IDBASKETITEM_SEQ. 
Run the procedure with the following values:
• Basket ID—14
• Product ID—8
• Price—10.80
• Quantity—1
• Size code—2
• Form code—4*/

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

/*PROBLEM 9
The home page of the Brewbean’s Web site has an option for members to log on with their IDs and passwords. Develop a procedure named MEMBER_CK_SP that accepts the ID and password as inputs, checks whether they make up a valid logon, and returns the member name and cookie value. The name should be returned as a single text string containing the first and last name. 
The head developer wants the number of parameters minimized so that the same
parameter is used to accept the password and return the name value. Also, if the user doesn’t
enter a valid username and password, return the value INVALID in a parameter named
p_check. Test the procedure using a valid logon first, with the username rat55 and password
kile. Then try it with an invalid logon by changing the username to rat.*/

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










