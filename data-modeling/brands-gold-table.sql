-- original view 
SELECT * FROM BRANDS_VIEW; 


-- Category and category code has same column values and we are dropping one of them to reduce duplication 

CREATE OR REPLACE VIEW BRANDS_GOLD AS 
SELECT ID,BAR_CODE, CPG_ID,CPG_REF, BRAND_NAME, BRAND_CODE, CATEGORY, TOP_BRAND
FROM BRANDS_VIEW
; 

SELECT * FROM BRANDS_GOLD ;  -- GOLD layer for brands data 


