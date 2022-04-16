DROP SEQUENCE ADD_CUSTOMER;
DROP SEQUENCE MY_FIRST_SEQ;
DROP INDEX CUSTOMERS_BITMAP;

/*PROBLEM 1
Create a sequence for populating the Customer# column of the CUSTOMERS table. When
setting the start and increment values, keep in mind that data already exists in this table.*/

CREATE SEQUENCE ADD_CUSTOMER
START WITH 1021
INCREMENT BY 1;

/*PROBLEM 2
Add a new customer row by using the sequence created in Question 1. The only data
currently available for the customer is as follows: last name = Shoulders, first name =
Frank, and zip = 23567.*/

INSERT INTO CUSTOMERS (CUSTOMER#, LASTNAME, FIRSTNAME, ZIP)
VALUES (ADD_CUSTOMER.NEXTVAL, 'SHOULDERS', 'FRANK', '23567');

/*PROBLEM 3
Create a sequence that generates integers starting with the value 5. Each value should be
three less than the previous value generated. The lowest possible value should be 0, and
the sequence shouldn’t be allowed to cycle. Name the sequence MY_FIRST_SEQ.*/

CREATE SEQUENCE MY_FIRST_SEQ
START WITH 5
INCREMENT BY -3
MAXVALUE 5
MINVALUE 0
NOCYCLE;

/*PROBLEM 4
Issue a SELECT statement that displays NEXTVAL for MY_FIRST_SEQ three times.
Because the value isn’t being placed in a table, use the DUAL table in the FROM clause of
the SELECT statement. What causes the error on the third SELECT?*/

SELECT MY_FIRST_SEQ.NEXTVAL FROM DUAL;
SELECT MY_FIRST_SEQ.NEXTVAL FROM DUAL;
SELECT MY_FIRST_SEQ.NEXTVAL FROM DUAL;

/*PROBLEM 5
Change the setting of MY_FIRST_SEQ so that the minimum value that can be generated is
–1000.*/

ALTER SEQUENCE MY_FIRST_SEQ
MINVALUE -1000;

/*PROBLEM 9
Create a bitmap index on the CUSTOMERS table to speed up queries that search for
customers based on their state of residence. Verify that the index exists, and then delete
the index.*/

CREATE BITMAP INDEX CUSTOMERS_BITMAP ON CUSTOMERS(STATE);

SELECT INDEX_NAME FROM USER_INDEXES;

DROP INDEX CUSTOMERS_BITMAP;



