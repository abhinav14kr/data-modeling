Hello,

Based on my recent work involving some exploration of database, schemas and data tables, I would like to ask some questions, raise potential concerns and gain some insights to build on my work.

## 1. Questions about the data?

What are the sources for the data, what is the cadence at which it is collected and who does it mainly serve? This is a good place to start to understand the bigger picture.

## 2. Discovering data quality issues? 

I came across some potential data quality issues with a lot of data duplication at both row and columnar level including a lot nulls or blank values using SQL window and partition functions.

Example:

* Flattened users.json had a lot of duplicates values, which was deduplicated to be stored in USERS_VIEW_DEDUPED  as a gold layer
* The tables RECEIPT_META_DETAILS and RECEIPT_USER_FLAGGED contains columns similar to what is already present in the RECEIPT_ITEM_DETAILS and these 2 tables have a lot null values. 

## 3. What do I need to know to resolve the data quality issues?

* I would like to understand the distinction in these similar yet stored in a separate column data, and if it is serving any business logic? I don’t see the need to duplicate given the storage and compute overhead. 
* If this is raw data in the data lake, I can build a separate ETL pipeline to clean, transform, and structure it for various teams. However, if this is already transformed data, I’d prefer to restructure the pipeline if there is no value in maintaining certain values to ensure high-quality, accessible data downstream.

## 4. What other information would I need to help optimize the data assets?

To model the pipeline, getting the business context, info about frequently needed and accessed data are helpful to create schemas and tables that are easily accessible and performant. 

Example - 
* Frequently accessed data can be unnested and stored in relational tables without needing to parse JSON for simple queries, while keeping only infrequently accessed data can be part of JSON for easy maintanence
* RECEIPT_USER_FLAGGED and RECEIPT_META_DETAILS loos like replication of RECEIPT_ITEM_DETAILS, which can be merged to reduce storage and compute overhead. These two tables are also separated because of high null value occurences to reduce computational overhead for queries running in one big table. Decision to merge, or keep can be made based on need for this data.


## 5. What performance and scaling concerns do I anticipate in production and how do I plan to address them?

* With modern data warehouses offering nearly infinite storage and charging on compute, storing lots f unstructured raw data in production can be costly. If a simple SELECT * FROM TABLE_NAME with some condition ends up scanning one big table, it incrementally adds up to not just cost but also slow retrieval of data for analyst as query logic builds up with joins.   
* A sound business logic to collect and hold onto relevant data, structure model properly  will help to cull some of the data columns in production, having access to only what is needed.  
* A discussion around these topics could be really fruitful for our engineering, analytical and business efforts around the data we collect and own. 