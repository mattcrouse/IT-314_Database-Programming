SET SERVEROUTPUT ON SIZE 3000

/*PROBLEM 1
In the Brewbean’s application, a customer can ask to check whether all items in his or her
basket are in stock. In this assignment, you create a block that uses an explicit cursor to
retrieve all items in the basket and determine whether all items are in stock by comparing the
item quantity with the product stock amount. If all items are in stock, display the message
“All items in stock!” onscreen. If not, display the message “All items NOT in stock!” onscreen.
The basket number is provided with an initialized variable. Follow these steps:
1. In SQL Developer, open the assignment04-01.sql file in the Chapter04 folder.
2. Run the block. Notice that both a cursor and a record variable are created in the DECLARE
section. The cursor must be manipulated with explicit actions of OPEN, FETCH, and CLOSE.*/
DECLARE
   CURSOR cur_basket IS
     SELECT bi.idBasket, bi.quantity, p.stock
       FROM bb_basketitem bi INNER JOIN bb_product p
         USING (idProduct)
       WHERE bi.idBasket = 6;
   TYPE type_basket IS RECORD (
     basket bb_basketitem.idBasket%TYPE,
     qty bb_basketitem.quantity%TYPE,
     stock bb_product.stock%TYPE);
   rec_basket type_basket;
   lv_flag_txt CHAR(1) := 'Y';
BEGIN
   OPEN cur_basket;
   LOOP 
     FETCH cur_basket INTO rec_basket;
      EXIT WHEN cur_basket%NOTFOUND;
      IF rec_basket.stock < rec_basket.qty THEN lv_flag_txt := 'N'; END IF;
   END LOOP;
   CLOSE cur_basket;
   IF lv_flag_txt = 'Y' THEN DBMS_OUTPUT.PUT_LINE('All items in stock!'); END IF;
   IF lv_flag_txt = 'N' THEN DBMS_OUTPUT.PUT_LINE('All items NOT in stock!'); END IF;   
END;

/*PROBLEM 2
Brewbean’s wants to send a promotion via e-mail to shoppers. A shopper who has purchased
more than $50 at the site receives a $5 coupon for his or her next purchase over $25. A
shopper who has spent more than $100 receives a free shipping coupon.
The BB_SHOPPER table contains a column named PROMO for storing promotion codes.
Follow the steps to create a block with a CURSOR FOR loop to check the total spent by each
shopper and update the PROMO column in the BB_SHOPPER table accordingly. The cursor’s
SELECT statement contains a subquery in the FROM clause to retrieve the shopper totals. Using an explicit cursor to verify items in stock
because a cursor using a GROUP BY statement can’t use the FOR UPDATE clause. Its results are
summarized data rather than separate rows from the database.*/
DECLARE
   CURSOR cur_shopper IS
     SELECT a.idShopper, a.promo,  b.total                          
       FROM bb_shopper a, (SELECT b.idShopper, SUM(bi.quantity*bi.price) total
                            FROM bb_basketitem bi, bb_basket b
                            WHERE bi.idBasket = b.idBasket
                            GROUP BY idShopper) b
        WHERE a.idShopper = b.idShopper
     FOR UPDATE OF a.idShopper NOWAIT;
   lv_promo_txt CHAR(1);
BEGIN
  FOR rec_shopper IN cur_shopper LOOP
   lv_promo_txt := 'X';
   IF rec_shopper.total > 100 THEN 
          lv_promo_txt := 'A';
   END IF;
   IF rec_shopper.total BETWEEN 50 AND 99 THEN 
          lv_promo_txt := 'B';
   END IF;   
   IF lv_promo_txt <> 'X' THEN
     UPDATE bb_shopper
      SET promo = lv_promo_txt
      WHERE CURRENT OF cur_shopper;
   END IF;
  END LOOP;
  COMMIT;
END;

SELECT idShopper, s.promo, SUM(bi.quantity*bi.price) total
    FROM bb_shopper s INNER JOIN bb_basket b USING(idShopper)
        INNER JOIN bb_basketitem bi USING(idBasket)
    GROUP BY idShopper, s.promo
    ORDER BY idShopper;

/*PROBLEM 3
The BB_SHOPPER table in the Brewbean’s database contains a column named PROMO that
specifies promotions to send to shoppers. This column needs to be cleared after the promotion
has been sent. First, open the assignment04-03.txt file in the Chapter04 folder in a text
editor (such as Notepad). Run the UPDATE and COMMIT statements at the top of this file (not
the anonymous block at the end). Modify the anonymous block so that it displays the number of
rows updated onscreen. Run the block.*/
DECLARE
    rows_updated NUMBER := 0;
BEGIN
    UPDATE bb_shopper
      SET promo = NULL;
      rows_updated := rows_updated + SQL%ROWCOUNT;
    UPDATE bb_shopper
      SET promo = 'B'
      WHERE idShopper IN (21,23,25);
      rows_updated := rows_updated + SQL%ROWCOUNT;
    UPDATE bb_shopper
      SET promo = 'A'
      WHERE idShopper = 22;
      rows_updated := rows_updated + SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ROWS UPDATED: '||rows_updated);
END;

/*PROBLEM 4
In this assignment, you test a block containing a CASE statement for errors, and then add an
exception handler for a predefined exception:
1. In Notepad, open the assignment04-04.sql file in the Chapter04 folder. Review the
block, which contains a CASE statement and no exception handlers.
2. Copy and paste the block into SQL Developer, and run the block. An error is raised because the state of NJ isn’t included in the CASE
statement; recall that a CASE statement must find a matching case. To correct this problem, add a predefined EXCEPTION handler that addresses this error
and displays “No tax” onscreen.
4. Run the block again. Now the error is handled in
the block’s EXCEPTION section.*/ 
DECLARE
    lv_tax_num NUMBER(2,2);
BEGIN
    CASE  'NJ' 
        WHEN 'VA' THEN lv_tax_num := .04;
        WHEN 'NC' THEN lv_tax_num := .02;  
        WHEN 'NY' THEN lv_tax_num := .06;  
    END CASE;
    DBMS_OUTPUT.PUT_LINE('tax rate = '||lv_tax_num);
EXCEPTION
    WHEN CASE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No tax');
END;
