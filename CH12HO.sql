/*PROBLEM 1*/


/*PROBLEM 2*/
SELECT C.FIRST, C.LAST
FROM CRIMINALS C JOIN CRIMES CS ON C.CRIMINAL_ID = CS.CRIMINAL_ID
WHERE C.V_STATUS != 'Y'
GROUP BY FIRST, LAST
HAVING COUNT(*) < (SELECT COUNT(CS.CRIMINAL_ID) / COUNT(DISTINCT CS.CRIMINAL_ID) FROM CRIMES);

/*PROBLEM 3*/
SELECT * FROM APPEALS
GROUP BY APPEAL_ID, CRIME_ID, FILING_DATE, HEARING_DATE, STATUS
HAVING AVG(HEARING_DATE - FILING_DATE) < (SELECT AVG(HEARING_DATE - FILING_DATE)FROM APPEALS);

/*PROBLEM 4*/
SELECT P.FIRST, P.LAST
FROM PROB_OFFICERS P
JOIN SENTENCES S ON P.PROB_ID = S.PROB_ID
GROUP BY FIRST, LAST
HAVING COUNT(*) < (SELECT COUNT(PROB_ID) / COUNT(DISTINCT PROB_ID) FROM SENTENCES);

/*PROBLEM 5*/
SELECT CRIME_ID
FROM APPEALS
GROUP BY CRIME_ID
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM APPEALS
                    GROUP BY CRIME_ID);

/*PROBLEM 6*/
SELECT *
FROM CRIME_CHARGES
WHERE FINE_AMOUNT >
    (SELECT AVG(NVL(FINE_AMOUNT, 0)) FROM CRIME_CHARGES)  AND
    AMOUNT_PAID < (SELECT AVG(NVL(AMOUNT_PAID, 0)) FROM CRIME_CHARGES);

/*PROBLEM 7*/
SELECT C.FIRST, C.LAST
FROM CRIMINALS C JOIN CRIMES CS ON C.CRIMINAL_ID = CS.CRIMINAL_ID
JOIN CRIME_CHARGES CC ON CS.CRIME_ID = CC.CRIME_ID
WHERE CRIME_CODE IN (SELECT CRIME_CODE FROM CRIME_CHARGES WHERE CRIME_ID = 10089)
GROUP BY FIRST, LAST;

/*PROBLEM 8*/
SELECT *
FROM CRIMINALS C
WHERE EXISTS (SELECT CRIMINAL_ID FROM SENTENCES S 
                WHERE C.CRIMINAL_ID = S.CRIMINAL_ID AND TYPE = 'P');

/*PROBLEM 9*/
SELECT O.FIRST, O.LAST
FROM OFFICERS O JOIN CRIME_OFFICERS OI ON O.OFFICER_ID = OI.OFFICER_ID
GROUP BY FIRST, LAST
HAVING COUNT(*) = (SELECT MAX(COUNT(OFFICER_ID)) FROM CRIME_OFFICERS 
                    GROUP BY OFFICER_ID);

/*PROBLEM 10*/
MERGE INTO CRIMINALS_DW A
USING CRIMINALS B
ON (A.CRIMINAL_ID = B.CRIMINAL_ID)
WHEN MATCHED THEN
    UPDATE SET A.V_STATUS = B.V_STATUS, A.P_STATUS = B.P_STATUS
WHEN NOT MATCHED THEN
    INSERT (CRIMINAL_ID, LAST, FIRST, STREET, CITY, STATE, ZIP, PHONE, V_STATUS, P_STATUS)
    VALUES (B.CRIMINAL_ID, B.LAST, B.FIRST, B.STREET, B.CITY, B.STATE, B.ZIP, B.PHONE, 
            B.V_STATUS, B.P_STATUS);

SELECT*
FROM CRIMINALS_DW;










