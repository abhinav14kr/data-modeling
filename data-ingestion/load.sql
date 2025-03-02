-- CREATING TABLES TO INJEST THE JSON FILES STORED IN SNOWFLAKE STAGE AREA
CREATE OR REPLACE TABLE brands (
  product_data VARIANT
);

CREATE OR REPLACE TABLE receipts (
  product_data VARIANT
);

CREATE OR REPLACE TABLE users_details (
  product_data VARIANT
);



-- INSERTING SPECIFIC JSON INTO THE TABLES CREATED ABOVE 
COPY INTO brands 
FROM @JSON_FILES/brands.json
FILE_FORMAT = my_json_format
ON_ERROR = 'continue';


COPY INTO receipts 
FROM @JSON_FILES/receipts.json
FILE_FORMAT = my_json_format
ON_ERROR = 'continue';

COPY INTO users_details 
FROM @JSON_FILES/users.json
FILE_FORMAT = my_json_format
ON_ERROR = 'continue';


-- SUCCESSFUL INGEST CAN BE CHECKED BY DOING A SELECT * on the above tables. 



-- UNNESTING THE JSON INGESTED INTO EACH TABLE TO CREATE A RELATIONAL MODEL 

-- injesting brands.json value to create a relational data model 
CREATE OR REPLACE VIEW brands_view AS
SELECT 
  product_data:_id['$oid']::STRING as id,
  product_data:barcode::STRING as bar_code,
  product_data:name::STRING as brand_name,
  product_data:category::STRING as category,
  product_data:categoryCode::STRING as category_code,
  product_data:brandCode::STRING as brand_code,
  product_data:cpg['$id']['$oid']::STRING as cpg_id,
  product_data:cpg['$ref']::STRING as cpg_ref,
  product_data:topBrand::BOOLEAN as top_brand
FROM brands;




-- injesting receipts.json value to create a relational data model 

CREATE OR REPLACE VIEW receipts_view AS
SELECT 
 product_data:_id['$oid']::STRING as receipt_id,
 product_data:bonusPointsEarned::NUMBER as bonus_points_earned,
 product_data:bonusPointsEarnedReason::STRING as bonus_points_earned_reason,
 DATEADD(millisecond, product_data:createDate['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as create_date,
 DATEADD(millisecond, product_data:dateScanned['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as date_scanned,
 DATEADD(millisecond, product_data:finishedDate['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as finished_date,
 DATEADD(millisecond, product_data:modifyDate['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as modify_date,
 DATEADD(millisecond, product_data:pointsAwardedDate['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as points_awarded_date,
 product_data:pointsEarned::NUMBER as points_earned,
 DATEADD(millisecond, product_data:purchaseDate['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as purchase_date,
 product_data:purchasedItemCount::NUMBER as purchase_item_count,
 product_data:rewardsReceiptStatus::STRING as rewards_receipt_status,
 product_data:totalSpent::NUMBER as total_spent,
 product_data:userId::STRING as user_id,
 product_data:rewardsReceiptItemList as rewards_receipt_item_list
FROM receipts;




-- injesting users.json value to create a relational data model 
CREATE OR REPLACE VIEW users_view AS
SELECT 
  product_data:_id['$oid']::STRING as user_id,
  product_data:active::BOOLEAN as is_active,
  DATEADD(millisecond, product_data:createdDate['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as created_date,
  DATEADD(millisecond, product_data:lastLogin['$date']::NUMBER, '1970-01-01')::TIMESTAMP_NTZ as last_login,
  product_data:role::STRING as user_role,
  product_data:signUpSource::STRING as sign_up_source,
  product_data:state::STRING as state
FROM users_details;






