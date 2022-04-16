SET SERVEROUTPUT ON SIZE 3000

/*PROBLEM 1*/
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

/*PROBLEM 2*/
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

/*PROBLEM 3*/
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

/*PROBLEM 4*/
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
