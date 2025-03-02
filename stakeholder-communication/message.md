Hello,

Based on my recent work involving some exploration of database, schemas and data tables, I would like to ask some questions, raise potential concerns and gain some insights to build on my work.

General Questions: What are the sources for the data, what is the cadence at which it is collected and who does it mainly serve? This is a good place to start to understand the bigger picture.

Quality Issues and Next Steps: In my initial analysis, I came across some potential data quality issues that I would like to flag. I found a lot of data duplication at both row and columnar level including a lot nulls or blank values. I confirmed the dupes to ensure i am not missing any unique identifier to classify them as dupes using basic SQL window functions, that helped me partition.

I would love to understand the reasoning behind existing state of things as I do not see how having it duplicated serves purpose at the cost of storage or compute overhead? If this is the raw data in the data lake, I can create an ETL pipeline to clean, transform and store structured data into schemas and tables serving various teams and use-cases leaving raw data untouched. However, if it is the latter with this already being a transformed data, I would like to re-structure the pipeline and supply good quality and easily accessible data downstream.


Optimization Techniques, Performance and Scaling: To model the pipeline, getting the business context, info about frequently needed or accessed data are helpful to model data with schemas and tables that are easily accessible and performant.

Accessibility of data inside JSON could become cumbersome for daily use case and reporting. Creating a structured relational data model with data marts serving specific teams with easy and quick access could make things easier for analysts. Chunking the data separate tables could also lead to performance issues if join operations are performed often. By addressing these points, we can optimize storage and compute and have a long term vision for scaling too.

A sound business logic to collect and hold onto relevant data will help to cull some of the data columns in production, having access to only what is needed.  


A discussion around these topics could be really fruitful for our engineering, analytical and business efforts around the data we collect and own. 