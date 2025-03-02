SELECT * FROM USERS_VIEW; 

-- This view has a total of 495 rows but only 212 unique rows with a lot of dupes found using the following query 

WITH DEDUPED AS (
    SELECT *, 
    ROW_NUMBER () OVER (PARTITION BY USER_ID, IS_ACTIVE, CREATED_DATE, LAST_LOGIN, USER_ROLE, SIGN_UP_SOURCE, STATE ORDER BY USER_ID) AS ranked
    FROM USERS_VIEW
    )
    
SELECT * FROM DEDUPED 
WHERE ranked = 1
; 


-- We only save the unique rows leaving out the dupes in a new table 

CREATE OR REPLACE VIEW USERS_DETAILS_GOLD AS -- this final version stored in GOLD layer for users data


WITH DEDUPED AS (
    SELECT *, 
    ROW_NUMBER () OVER (PARTITION BY USER_ID, IS_ACTIVE, CREATED_DATE, LAST_LOGIN, USER_ROLE, SIGN_UP_SOURCE, STATE ORDER BY USER_ID) AS ranked
    FROM USERS_VIEW
    )
    
SELECT * FROM DEDUPED 
WHERE ranked = 1
; 

