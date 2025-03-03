Hello,

Based on my recent work involving some exploration of database, schemas and data tables, I would like to ask some questions, raise potential concerns and gain some insights to build on my work.

1. What questions do you have about the data?

What are the sources for the data, what is the cadence at which it is collected and who does it mainly serve? This is a good place to start to understand the bigger picture.

2. How did you discover the data quality issues? 

In my initial analysis, I came across some potential data quality issues that I would like to flag. I found a lot of data duplication at both row and columnar level including a lot nulls or blank values. I confirmed the dupes to ensure i am not missing any unique identifier to classify them as dupes using basic SQL window functions, that helped me partition.

Example - 
    -> Flattened users.json had a lot of duplicates values, which was deduplicated to be stored in USERS_VIEW_DEDUPED  as a gold layer
    -> The tables RECEIPT_META_DETAILS and RECEIPT_USER_FLAGGED contains columns similar to what is already present in the RECEIPT_ITEM_DETAILS and these 2 tables have a lot null values. 

3. What do you need to know to resolve the data quality issues?

 -> I would like to understand the distinction in these similar yet stored in a separate column data points, and if it is serving any business logic? I don’t see the need to duplicate given the storage and compute overhead. 
 -> If this is raw data in the data lake, I can build an ETL pipeline to clean, transform, and structure it for various teams, accessing only what is needed leaving the raw data untouched. However, if this is already transformed data, I’d prefer to restructure the pipeline if there is no value in maintaining these values to ensure high-quality, accessible data downstream.

4. What other information would you need to help you optimize the data assets you're trying to create?

To model the pipeline, getting the business context, info about frequently needed or accessed data are helpful to create schemas and tables that are easily accessible and performant. 

Example - 
    -> Frequently accessed data can be unnested and stored in relational tables for easy access without needing to parse JSON, and on the other hand infrequently access data can be part of JSON for easy maintanence
    -> Data marts can be created to service specific teams and business use-cases. A good balance of having separate data tables for frequently accessed data yet reducing join operations for cross table data access and transactions to reduce join overload must be achieved.
    -> RECEIPT_USER_FLAGGED and RECEIPT_META_DETAILS are tables with columns having similar values from RECEIPT_ITEM_DETAILS, which can be merged to reduce storage and compute overhead. These two tables are also separated because of high null value occurences to reduce computational overhead for queries running in one big table. Decision to merge, or keep can be made based on inputs.


5. What performance and scaling concerns do you anticipate in production and how do you plan to address them?

    -> With a lot of the new DW solutions providing storage that is almost infinitely scalable and charging on compute, it is important to keep data clean and structured to avoid unneccesary compute costs. Even a simple query that scans the entire table with lot of nulls and duplicate can be expensive computationally.  
    -> A sound business logic to collect and hold onto relevant data, structure model properly  will help to cull some of the data columns in production, having access to only what is needed.  
    -> A discussion around these topics could be really fruitful for our engineering, analytical and business efforts around the data we collect and own. 