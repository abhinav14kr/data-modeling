-- 1. users.json had a lot of duplicates. For context before deduping, the COUNT(*) was 395 and after deduplicating the count(*) was 212 

WITH DEDUPED AS (
    SELECT *, 
    ROW_NUMBER () OVER (PARTITION BY USER_ID, IS_ACTIVE, CREATED_DATE, LAST_LOGIN, USER_ROLE, SIGN_UP_SOURCE, STATE ORDER BY USER_ID) AS ranked
    FROM USERS_VIEW -- users.json was loaded onto this view in snowflake through stage
    )

SELECT * FROM DEDUPED 
WHERE ranked = 1
; 


-- 2. brands.json 

-- The Category and Category_code columns are pretty similar. The Category code has a lot of null values and for the non-null values, the similarity score tells we can do with one column, and have a more unique identifier as category code if required. 

SELECT 
    CATEGORY,
    CATEGORY_CODE,
    CASE 
        WHEN CONTAINS(UPPER(CATEGORY), UPPER(CATEGORY_CODE)) THEN 1.0
        WHEN CONTAINS(UPPER(CATEGORY_CODE), UPPER(CATEGORY)) THEN 0.8
        ELSE 0.0
    END AS match_score
FROM BRANDS_VIEW
WHERE CATEGORY IS NOT NULL AND CATEGORY_CODE IS NOT NULL;


-- 3. receipts.json

-- no difference in timeframe in day, hour and minute between DATE_SCANNED and CREATE_DATE. Unless required it to be unique, we can do with one column. 

SELECT
    DATEDIFF(day, CREATE_DATE, DATE_SCANNED) AS days_difference,
    DATEDIFF(hour, CREATE_DATE, DATE_SCANNED) AS hours_difference,
    DATEDIFF(minute, CREATE_DATE, DATE_SCANNED) AS minutes_difference
FROM
    RECEIPTS_VIEW;



-- 4. Post Data MOdeling 


-- the unflattended json column inside the RECEIPTS_VIEW can be seen having multiple entries of the same item for certain receipts  
-- query
SELECT * FROM RECEIPTS_VIEW
WHERE RECEIPT_ID = '5ffcb4900a720f0515000002'; 


-- output (The JSON array contains 10 identical entries for Miller Lite 24-packs where the only difference is the sequential partnerItemId values (1 through 10).)
[
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "1",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "2",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "3",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "4",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "5",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "6",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "7",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "8",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "9",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  },
  {
    "barcode": "034100573065",
    "description": "MILLER LITE 24 PACK 12OZ CAN",
    "finalPrice": "29",
    "itemPrice": "29",
    "partnerItemId": "10",
    "pointsEarned": "870.0",
    "pointsPayerId": "5332f709e4b03c9a25efd0f1",
    "quantityPurchased": 1,
    "rewardsGroup": "MILLER LITE 24 PACK",
    "rewardsProductPartnerId": "5332f709e4b03c9a25efd0f1",
    "targetPrice": "77"
  }
]




-- 5. null values and sparse data 
-- The receipts.json after flattening has a column REWARDS_RECEIPT_ITEM_LIST which has a JSON Structure again. 
-- When flattening this json further, there seems to be a lot of duplicate columns or columns with high null values in it. 
-- These are separated and stored in separate table based on some similarity context lile REWARDS, USER_FLAGGED, META_DETAILS, etc. 

-- Query

SELECT * FROM RECEIPT_USER_FLAGGED

SELECT * FROM RECEIPT_META_DETAILS 


SELECT 
    ORIGINALMETABRITEDESCRIPTION, 
    ORIGINALMETABRITEQUANTITYPURCHASED, 
    ORIGINALMETABRITEITEMPRICE, 
    ORIGINALFINALPRICE  
    -- Less than 0.5 % non-null values in these columns that seem to not give too much context in the first place
FROM RECEIPT_USER_FLAGGED ; 


SELECT 
    ORIGINALMETABRITEDESCRIPTION, 
    ORIGINALMETABRITEQUANTITYPURCHASED, 
    ORIGINALMETABRITEITEMPRICE, 
    ORIGINALFINALPRICE 
    -- ( less than 5 % non-null values in these columns that seem to not give too much context in the first place)
FROM RECEIPT_META_DETAILS ; 



