/*PROBLEM 1
 List the name of each officer who has reported more than the average number of crimes
officers have reported.*/

SELECT O.FIRST, O.LAST 
FROM OFFICERS O JOIN CRIME_OFFICERS CO ON O.OFFICER_ID = CO.OFFICER_ID
GROUP BY FIRST, LAST
HAVING COUNT(*) > (SELECT COUNT(OFFICER_ID) / COUNT(DISTINCT OFFICER_ID)
                     FROM CRIME_OFICERS);


/*PROBLEM 2
List the names of all criminals who have committed less than average number of crimes
and aren’t listed as violent offenders.*/

SELECT C.FIRST, C.LAST
FROM CRIMINALS C JOIN CRIMES CS ON C.CRIMINAL_ID = CS.CRIMINAL_ID
WHERE C.V_STATUS != 'Y'
GROUP BY FIRST, LAST
HAVING COUNT(*) < (SELECT COUNT(CS.CRIMINAL_ID) / COUNT(DISTINCT CS.CRIMINAL_ID) FROM CRIMES);

/*PROBLEM 3
List appeal information for each appeal that has a less than average number of days
between the filing and hearing dates.*/

SELECT * FROM APPEALS
GROUP BY APPEAL_ID, CRIME_ID, FILING_DATE, HEARING_DATE, STATUS
HAVING AVG(HEARING_DATE - FILING_DATE) < (SELECT AVG(HEARING_DATE - FILING_DATE)FROM APPEALS);

/*PROBLEM 4
List the names of probation officers who have had a less than average number of criminals
Assigned.*/

SELECT P.FIRST, P.LAST
FROM PROB_OFFICERS P
JOIN SENTENCES S ON P.PROB_ID = S.PROB_ID
GROUP BY FIRST, LAST
HAVING COUNT(*) < (SELECT COUNT(PROB_ID) / COUNT(DISTINCT PROB_ID) FROM SENTENCES);

/*PROBLEM 5
List each crime that has had the highest number of appeals recorded.*/

SELECT CRIME_ID
FROM APPEALS
GROUP BY CRIME_ID
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM APPEALS
                    GROUP BY CRIME_ID);

/*PROBLEM 6
List the information on crime charges for each charge that has had a fine above average
and a sum paid below average.*/

SELECT *
FROM CRIME_CHARGES
WHERE FINE_AMOUNT >
    (SELECT AVG(NVL(FINE_AMOUNT, 0)) FROM CRIME_CHARGES)  AND
    AMOUNT_PAID < (SELECT AVG(NVL(AMOUNT_PAID, 0)) FROM CRIME_CHARGES);

/*PROBLEM 7
List the names of all criminals who have had any of the crime code charges involved in
crime ID 10089.*/

SELECT C.FIRST, C.LAST
FROM CRIMINALS C JOIN CRIMES CS ON C.CRIMINAL_ID = CS.CRIMINAL_ID
JOIN CRIME_CHARGES CC ON CS.CRIME_ID = CC.CRIME_ID
WHERE CRIME_CODE IN (SELECT CRIME_CODE FROM CRIME_CHARGES WHERE CRIME_ID = 10089)
GROUP BY FIRST, LAST;

/*PROBLEM 8
Use a correlated subquery to determine which criminals have had at least one probation
period assigned.*/

SELECT *
FROM CRIMINALS C
WHERE EXISTS (SELECT CRIMINAL_ID FROM SENTENCES S 
                WHERE C.CRIMINAL_ID = S.CRIMINAL_ID AND TYPE = 'P');

/*PROBLEM 9
List the names of officers who have booked the highest number of crimes. Note that more
than one officer might be listed.*/

SELECT O.FIRST, O.LAST
FROM OFFICERS O JOIN CRIME_OFFICERS OI ON O.OFFICER_ID = OI.OFFICER_ID
GROUP BY FIRST, LAST
HAVING COUNT(*) = (SELECT MAX(COUNT(OFFICER_ID)) FROM CRIME_OFFICERS 
                    GROUP BY OFFICER_ID);

/*PROBLEM 10
The criminal data warehouse contains a copy of the CRIMINALS table that needs to be
updated periodically from the production CRIMINALS table. The data warehouse table is
named CRIMINALS_DW. Use a single SQL statement to update the data warehouse table
to reflect any data changes for existing criminals and to add new criminals.*/

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











