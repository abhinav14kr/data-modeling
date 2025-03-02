-- Question 1 When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT 
    r.REWARDS_RECEIPT_STATUS,
    AVG(r.TOTAL_SPENT) as average_spend
FROM RECEIPTS_VIEW r
WHERE r.REWARDS_RECEIPT_STATUS IN ('FINISHED', 'REJECTED')
GROUP BY r.REWARDS_RECEIPT_STATUS;

Answer: 

Average of total spent from receipts with 'rewardsReceiptStatus' as 'Accepted' is 80.862934

Average of total spent from receipts with 'rewardsReceiptStatus' as 'Rejected' is 23.352113

-- There is no Accepted status in the column so I went with 'FINISHED' in the WHERE CLAUSE which states the average spend for receipts in Finished status is more


-- Question 2 When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
Total purchase_item_count from receipts with 'rewardsReceiptStatus' as 'Accepted' is 518

Total purchase_item_count from receipts with 'rewardsReceiptStatus' as 'Rejected' is 71



-- Question 3 Which brand has the most spend among users who were created within the past 6 months?
WITH FIRST_CTE AS (
    SELECT DISTINCT B.BRAND_NAME, R.RECEIPT_ID as receipt_id, (R.ITEMPRICE * R.QUANTITYPURCHASED) as mostspend
    FROM RECEIPT_ITEM_DETAILS R 
    JOIN BRANDS_GOLD B ON R.BARCODE = B.BAR_CODE
    ORDER BY mostspend DESC
), 

SECOND_CTE AS (
    SELECT  U.USER_ID as user_id, R.RECEIPT_ID
    FROM USERS_DETAILS_GOLD U
    JOIN RECEIPTS_VIEW R 
    ON U.USER_ID = R.USER_ID
    WHERE U.CREATED_DATE >= DATEADD(month, -6, '2021-02-12 14:11:06.240') -- calculated for 6 months before the max of user created date SELECT MAX(CREATED_DATE) FROM USERS_DETAILS_GOLD; 
)

SELECT s.USER_ID, f.brand_name,f.mostspend, s.receipt_id
FROM FIRST_CTE F 
JOIN SECOND_CTE S 
ON F.RECEIPT_ID = S.RECEIPT_ID ; 

ANSWER: Cracker Barrel Cheese with  among users who were created within the past 6 months


-- Question 4 Which brand has the most transactions among users who were created within the past 6 months?


WITH UsersCreatedLast6Months AS (
    SELECT U.USER_ID
    FROM USERS_DETAILS_GOLD U
    WHERE U.CREATED_DATE >= DATEADD(month, -6, '2021-02-12 14:11:06.240')
),
BrandTransactionsForUsers AS (
    SELECT
    B.BRAND_NAME,
    COUNT(DISTINCT R.RECEIPT_ID) AS transaction_count
    FROM RECEIPT_ITEM_DETAILS R
    JOIN BRANDS_GOLD B ON R.BARCODE = B.BAR_CODE
    JOIN RECEIPTS_VIEW RR ON R.RECEIPT_ID = RR.RECEIPT_ID
    WHERE RR.USER_ID IN (SELECT USER_ID FROM UsersCreatedLast6Months)
    GROUP BY B.BRAND_NAME
)
SELECT BRAND_NAME, transaction_count
FROM BrandTransactionsForUsers
ORDER BY transaction_count DESC
LIMIT 5;

ANSWER: Tostitos and Swanson involved in 11 transactions for purchases made by users created in the last 6 months