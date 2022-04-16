/*PROBLEM 1
List the book title and retail price for all books with a retail price lower than the average retail price of all books sold by JustLee Books. 
To complete problem 1, write an SQL query that uses a single-row subquery in a WHERE clause.*/

SELECT TITLE, RETAIL 
FROM BOOKS 
WHERE RETAIL < (SELECT AVG(RETAIL) FROM BOOKS);

/*PROBLEM 2
Determine which books cost less than the average cost of other books in the same category.
To complete problem 2, write an SQL query that uses a multiple-column subquery in a FROM clause. The subquery will use the GROUP BY statement.*/

SELECT TITLE, CATEGORY, COST
FROM BOOKS B 
WHERE COST < (SELECT AVG(COST) FROM BOOKS GROUP BY CATEGORY HAVING CATEGORY = B.CATEGORY);

/*PROBLEM 3
Determine which orders were shipped to the same state as order 1014.
To complete problem 3, write an SQL query that uses a single-row subquery in a WHERE clause.*/

SELECT ORDER#, SHIPSTATE 
FROM ORDERS
WHERE SHIPSTATE = (SELECT SHIPSTATE FROM ORDERS WHERE ORDER# = 1014);

/*PROBLEM 4
Determine which orders had a higher total amount due than order 1008.
To complete problem 4, write an SQL query that uses a single-row subquery in a HAVING clause. */

SELECT O.ORDER#, O.SHIPCOST + OI.PAIDEACH AS TOTAL
FROM ORDERS O
JOIN ORDERITEMS OI ON O.ORDER# = OI.ORDER#
WHERE (OI.QUANTITY*OI.PAIDEACH + O.SHIPCOST) >
(SELECT OI.QUANTITY*OI.PAIDEACH + O.SHIPCOST
    FROM ORDERS O
    JOIN ORDERITEMS OI ON O.ORDER# = OI.ORDER#
    WHERE OI.ORDER# = 1008);

/*PROBLEM 5
Determine which author or authors wrote the books most frequently purchased by customers of JustLee Books.
To complete problem 5, write an SQL query that uses a multiple-row subquery in a WHERE clause. 
The subquery will include the GROUP BY statement and another multiple-row subquery in a HAVING clause.*/

SELECT A.FNAME, A.LNAME
FROM BOOKAUTHOR BA
JOIN AUTHOR A ON BA.AUTHORID = A.AUTHORID
WHERE ISBN IN (SELECT ISBN FROM ORDERITEMS GROUP BY ISBN HAVING SUM(QUANTITY) =
(SELECT MAX(COUNT(QUANTITY)) FROM ORDERITEMS GROUP BY ISBN));

/*PROBLEM 6
List the title of all books in the same category as books previously purchased by customer 1007. Don’t include books this customer has already purchased.
To complete problem 6, write an SQL query that uses two multiple-row subqueries in a WHERE clause joined with the AND operator. 
Each subquery will join multiple tables.*/

SELECT TITLE
FROM BOOKS
WHERE CATEGORY IN(SELECT DISTINCT CATEGORY
FROM BOOKS B JOIN ORDERITEMS OI ON B.ISBN = OI.ISBN
JOIN ORDERS O ON OI.ORDER# = O.ORDER#
WHERE O.CUSTOMER# = 1007)
AND ISBN NOT IN (SELECT ISBN
FROM ORDERS O JOIN ORDERITEMS OI ON O.ORDER# = OI.ORDER#
WHERE O.CUSTOMER# = 1007);

/*PROBLEM 7
List the shipping city and state for the order that had the longest shipping delay.
To complete problem 7, write an SQL query that uses a single-row subquery in a WHERE clause.*/

SELECT SHIPCITY, SHIPSTATE
FROM ORDERS
WHERE SHIPDATE - ORDERDATE =
(SELECT MAX(SHIPDATE - ORDERDATE)
FROM ORDERS);

/*PROBLEM 8
Determine which customers placed orders for the least expensive book (in terms of regular retail price) carried by JustLee Books.
To complete problem 8, write an SQL query that joins four tables and uses a single-row subquery in a WHERE clause.*/

SELECT C.CUSTOMER#
FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER# = O.CUSTOMER# 
JOIN ORDERITEMS OI ON OI.ORDER# = O.ORDER#
JOIN BOOKS B ON B.ISBN = OI.ISBN
WHERE RETAIL = (SELECT MIN(RETAIL)
FROM BOOKS);

/*PROBLEM 9
Determine the number of different customers who have placed an order for books written or cowritten by James Austin.
To complete problem 9, write an SQL query that joins two tables and uses a multiple-row subquery in a WHERE clause. The subquery will join three tables.*/

SELECT COUNT(DISTINCT C.CUSTOMER#) AS DIFFERENT_CUSTOMERS
FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER# = O.CUSTOMER#
JOIN ORDERITEMS OI ON O.ORDER# = OI.ORDER#
WHERE ISBN IN (SELECT BA.ISBN FROM BOOKAUTHOR BA JOIN ORDERITEMS OI ON BA.ISBN = OI.ISBN
                AND BA.AUTHORID = 'A100');

/*PROBLEM 10
Determine which books were published by the publisher of The Wok Way to Cook.
To complete problem 10, write an SQL query that uses a single-row subquery in a WHERE clause.*/

SELECT TITLE
FROM BOOKS
WHERE PUBID IN (SELECT PUBID FROM BOOKS WHERE TITLE = 'THE WOK WAY TO COOK');









