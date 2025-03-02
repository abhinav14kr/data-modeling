-- UNNEST THE COLUMN REWARDS_RECEIPT_ITEM_LIST which has a lot of key value pairs and put it into a separate table REWARDS_RECEIPT_ITEM_LIST_UNNESTED
CREATE TABLE REWARDS_RECEIPT_ITEM_LIST_UNNESTED (
    receipt_item_id INT IDENTITY(1,1) PRIMARY KEY,
    receipt_id STRING,
    -- Fields from your JSON array
    barcode STRING,
    description STRING,
    finalPrice NUMBER,
    itemPrice NUMBER,
    needsFetchReview BOOLEAN,
    preventTargetGapPoints BOOLEAN,
    quantityPurchased NUMBER,
    userFlaggedBarcode STRING,
    pointsPayerId STRING,
    rewardsProductPartnerId STRING,
    userFlaggedDescription STRING,
    originalMetaBriteBarcode STRING,
    originalMetaBriteDescription STRING,
    competitorRewardsGroup STRING,
    discountedItemPrice NUMBER,
    originalReceiptItemText STRING,
    originalMetaBriteQuantityPurchased NUMBER,
    pointsEarned NUMBER,
    targetPrice NUMBER,
    originalMetaBriteItemPrice NUMBER,
    metabriteCampaignId STRING,
    partnerItemId STRING,
    userFlaggedPrice NUMBER,
    itemNumber STRING,
    competitiveProduct BOOLEAN,
    originalFinalPrice NUMBER,
    deleted BOOLEAN,
    priceAfterCoupon NUMBER,
    userFlaggedNewItem BOOLEAN,
    userFlaggedQuantity NUMBER,
    needsFetchReviewReason STRING,
    rewardsGroup STRING,
    brandCode STRING,
    pointsNotAwardedReason STRING
);

INSERT INTO REWARDS_RECEIPT_ITEM_LIST_UNNESTED (
    receipt_id,
    barcode,
    description,
    finalPrice,
    itemPrice,
    needsFetchReview,
    preventTargetGapPoints,
    quantityPurchased,
    userFlaggedBarcode,
    pointsPayerId,
    rewardsProductPartnerId,
    userFlaggedDescription,
    originalMetaBriteBarcode,
    originalMetaBriteDescription,
    competitorRewardsGroup,
    discountedItemPrice,
    originalReceiptItemText,
    originalMetaBriteQuantityPurchased,
    pointsEarned,
    targetPrice,
    originalMetaBriteItemPrice,
    metabriteCampaignId,
    partnerItemId,
    userFlaggedPrice,
    itemNumber,
    competitiveProduct,
    originalFinalPrice,
    deleted,
    priceAfterCoupon,
    userFlaggedNewItem,
    userFlaggedQuantity,
    needsFetchReviewReason,
    rewardsGroup,
    brandCode,
    pointsNotAwardedReason
)
SELECT
    r.receipt_id,
    f.value:barcode::STRING,
    f.value:description::STRING,
    f.value:finalPrice::NUMBER,
    f.value:itemPrice::NUMBER,
    f.value:needsFetchReview::BOOLEAN,
    f.value:preventTargetGapPoints::BOOLEAN,
    f.value:quantityPurchased::NUMBER,
    f.value:userFlaggedBarcode::STRING,
    f.value:pointsPayerId::STRING,
    f.value:rewardsProductPartnerId::STRING,
    f.value:userFlaggedDescription::STRING,
    f.value:originalMetaBriteBarcode::STRING,
    f.value:originalMetaBriteDescription::STRING,
    f.value:competitorRewardsGroup::STRING,
    f.value:discountedItemPrice::NUMBER,
    f.value:originalReceiptItemText::STRING,
    f.value:originalMetaBriteQuantityPurchased::NUMBER,
    f.value:pointsEarned::NUMBER,
    f.value:targetPrice::NUMBER,
    f.value:originalMetaBriteItemPrice::NUMBER,
    f.value:metabriteCampaignId::STRING,
    f.value:partnerItemId::STRING,
    f.value:userFlaggedPrice::NUMBER,
    f.value:itemNumber::STRING,
    f.value:competitiveProduct::BOOLEAN,
    f.value:originalFinalPrice::NUMBER,
    f.value:deleted::BOOLEAN,
    f.value:priceAfterCoupon::NUMBER,
    f.value:userFlaggedNewItem::BOOLEAN,
    f.value:userFlaggedQuantity::NUMBER,
    f.value:needsFetchReviewReason::STRING,
    f.value:rewardsGroup::STRING,
    f.value:brandCode::STRING,
    f.value:pointsNotAwardedReason::STRING
FROM RECEIPTS_VIEW r,
LATERAL FLATTEN(input => r.REWARDS_RECEIPT_ITEM_LIST) f;






-- STORING THE UNNESTED VALUES BASED ON GROUPS AND NULL VALUES IN SEPARATE TABLES 
-- ITEM_DETAILS table (Core item information)
CREATE TABLE RECEIPT_ITEM_DETAILS (
    RECEIPT_ITEM_ID NUMBER AUTOINCREMENT PRIMARY KEY,
    RECEIPT_ID VARCHAR(16777216),
    BARCODE VARCHAR(16777216),
    DESCRIPTION VARCHAR(16777216),
    FINALPRICE NUMBER,
    ITEMPRICE NUMBER,
    QUANTITYPURCHASED NUMBER,
    PARTNERITEMID VARCHAR(16777216),
    ITEMNUMBER VARCHAR(16777216),
    DISCOUNTEDITEMPRICE NUMBER,
    PRICEAFTERCOUPON NUMBER,
    DELETED BOOLEAN
) CLUSTER BY (RECEIPT_ID); -- clustering by receipt_id to ensure join performance with other tables is optimized 

INSERT INTO RECEIPT_ITEM_DETAILS (
    RECEIPT_ID, 
    BARCODE, 
    DESCRIPTION, 
    FINALPRICE, 
    ITEMPRICE, 
    QUANTITYPURCHASED, 
    PARTNERITEMID, 
    ITEMNUMBER, 
    DISCOUNTEDITEMPRICE,
    PRICEAFTERCOUPON,
    DELETED
)
SELECT 
    RECEIPT_ID, 
    BARCODE, 
    DESCRIPTION, 
    FINALPRICE, 
    ITEMPRICE, 
    QUANTITYPURCHASED, 
    PARTNERITEMID, 
    ITEMNUMBER, 
    DISCOUNTEDITEMPRICE,
    PRICEAFTERCOUPON,
    DELETED
FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED;



-- FETCH_DETAILS table (Fetch review information)
CREATE TABLE RECEIPT_FETCH_DETAILS (
    RECEIPT_ITEM_ID NUMBER PRIMARY KEY,
    RECEIPT_ID VARCHAR(16777216),
    NEEDSFETCHREVIEW BOOLEAN,
    NEEDSFETCHREVIEWREASON VARCHAR(16777216)
) CLUSTER BY (RECEIPT_ID); -- clustering by receipt_id to ensure join performance with other tables is optimized 

INSERT INTO RECEIPT_FETCH_DETAILS (
    RECEIPT_ITEM_ID,
    RECEIPT_ID, 
    NEEDSFETCHREVIEW, 
    NEEDSFETCHREVIEWREASON
)
SELECT 
    RECEIPT_ITEM_ID, 
    RECEIPT_ID, 
    NEEDSFETCHREVIEW, 
    NEEDSFETCHREVIEWREASON
FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED;


-- RECEIPT_REWARD details stored in separate table UNNESTED FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED
CREATE TABLE RECEIPT_REWARD_DETAILS (
    RECEIPT_ITEM_ID NUMBER PRIMARY KEY,
    RECEIPT_ID VARCHAR(16777216),
    PARTNERITEMID VARCHAR(16777216),
    POINTSPAYERID VARCHAR(16777216),
    REWARDSPRODUCTPARTNERID VARCHAR(16777216),
    REWARDSGROUP VARCHAR(16777216),
    COMPETITORREWARDSGROUP VARCHAR(16777216),
    COMPETITIVEPRODUCT BOOLEAN,
    PREVENTTARGETGAPPOINTS BOOLEAN,
    POINTSNOTAWARDEDREASON VARCHAR(16777216),
    POINTSEARNED NUMBER,
    TARGETPRICE NUMBER,
    BRANDCODE VARCHAR(16777216)
) CLUSTER BY (RECEIPT_ID); -- clustering by receipt_id to ensure join performance with other tables is optimized 
 

-- Insert data into REWARD_DETAILS table
INSERT INTO RECEIPT_REWARD_DETAILS (
    RECEIPT_ITEM_ID,
    RECEIPT_ID,
    PARTNERITEMID,
    POINTSPAYERID,
    REWARDSPRODUCTPARTNERID,
    REWARDSGROUP,
    COMPETITORREWARDSGROUP,
    COMPETITIVEPRODUCT,
    PREVENTTARGETGAPPOINTS,
    POINTSNOTAWARDEDREASON,
    POINTSEARNED,
    TARGETPRICE,
    BRANDCODE
)
SELECT 
    RECEIPT_ITEM_ID,
    RECEIPT_ID,
    PARTNERITEMID,
    POINTSPAYERID,
    REWARDSPRODUCTPARTNERID,
    REWARDSGROUP,
    COMPETITORREWARDSGROUP,
    COMPETITIVEPRODUCT,
    PREVENTTARGETGAPPOINTS,
    POINTSNOTAWARDEDREASON,
    POINTSEARNED,
    TARGETPRICE,
    BRANDCODE
FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED;



-- USER_FLAGGED info stored in separate table UNNESTED FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED
CREATE TABLE RECEIPT_USER_FLAGGED (
    RECEIPT_ITEM_ID NUMBER PRIMARY KEY,
    RECEIPT_ID VARCHAR(16777216),
    USERFLAGGEDBARCODE VARCHAR(16777216),
    USERFLAGGEDDESCRIPTION VARCHAR(16777216),
    USERFLAGGEDPRICE NUMBER,
    USERFLAGGEDNEWITEM BOOLEAN,
    USERFLAGGEDQUANTITY NUMBER
) CLUSTER BY (RECEIPT_ID); -- clustering by receipt_id to ensure join performance with other tables is optimized 
-- Insert data into USER_FLAGGED table
INSERT INTO RECEIPT_USER_FLAGGED (
    RECEIPT_ITEM_ID,
    RECEIPT_ID,
    USERFLAGGEDBARCODE,
    USERFLAGGEDDESCRIPTION,
    USERFLAGGEDPRICE,
    USERFLAGGEDNEWITEM,
    USERFLAGGEDQUANTITY
)
SELECT 
    RECEIPT_ITEM_ID,
    RECEIPT_ID,
    USERFLAGGEDBARCODE,
    USERFLAGGEDDESCRIPTION,
    USERFLAGGEDPRICE,
    USERFLAGGEDNEWITEM,
    USERFLAGGEDQUANTITY
FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED;


-- meta details stored in a seprate table UNNESTED FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED
CREATE TABLE RECEIPT_META_DETAILS (
    RECEIPT_ITEM_ID NUMBER PRIMARY KEY,
    RECEIPT_ID VARCHAR(16777216),
    ORIGINALMETABRITEBARCODE VARCHAR(16777216),
    ORIGINALMETABRITEDESCRIPTION VARCHAR(16777216),
    ORIGINALRECEIPTITEMTEXT VARCHAR(16777216),
    ORIGINALMETABRITEQUANTITYPURCHASED NUMBER,
    ORIGINALMETABRITEITEMPRICE NUMBER,
    ORIGINALFINALPRICE NUMBER,
    METABRITECAMPAIGNID VARCHAR(16777216)
) CLUSTER BY (RECEIPT_ID); -- clustering by receipt_id to ensure join performance with other tables is optimized 
-- Insert data into META_DETAILS table
INSERT INTO RECEIPT_META_DETAILS (
    RECEIPT_ITEM_ID,
    RECEIPT_ID,
    ORIGINALMETABRITEBARCODE,
    ORIGINALMETABRITEDESCRIPTION,
    ORIGINALRECEIPTITEMTEXT,
    ORIGINALMETABRITEQUANTITYPURCHASED,
    ORIGINALMETABRITEITEMPRICE,
    ORIGINALFINALPRICE,
    METABRITECAMPAIGNID
)
SELECT 
    RECEIPT_ITEM_ID,
    RECEIPT_ID,
    ORIGINALMETABRITEBARCODE,
    ORIGINALMETABRITEDESCRIPTION,
    ORIGINALRECEIPTITEMTEXT,
    ORIGINALMETABRITEQUANTITYPURCHASED,
    ORIGINALMETABRITEITEMPRICE,
    ORIGINALFINALPRICE,
    METABRITECAMPAIGNID
FROM REWARDS_RECEIPT_ITEM_LIST_UNNESTED;


