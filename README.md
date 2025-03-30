# Data Modeling Assessment

This repository contains data modeling, ingestion, and analysis work for structuring and optimizing schema design for [Analytics Take Home Assessment](https://fetch-hiring.s3.amazonaws.com/analytics-engineer/ineeddata-data-modeling/data-modeling.html). 

![erd](https://github.com/user-attachments/assets/38cd8179-9135-48ce-94f1-eda115621c61)



## Project Overview

This assignment focuses on designing and implementing a structured data model for the given nested JSON data. The data includes information about users, brands, and receipts with complex nested structures.

## Platform 

The data injestion, modeling and querying is done on Snowflake platform. The SQL Queries in the directory in the exact order can be run on Snowflake platform to get the results seen with my work. 

## Data Sources

- **brands.json**: Contains brand information in the receipts
- **receipts.json**: Contains receipt data with nested line items, rewards information, and user references
- **users.json**: Contains user account information and metadata

## Data Modeling Approach

The repository demonstrates a multi-layered data modeling approach:

1. **Raw Data Ingestion**: Scripts in the `data-ingestion` folder handle the loading of raw JSON data into Snowflake stage
2. **Data Modeling**: SQL scripts in the `data-modeling` folder transform nested JSON into structured relational tables
3. **Data Quality**: Scripts in the `data-quality-issue` folder identify and address data quality issues
4. **Analytics**: The `questions` folder contains queries that answer the questions making use of the designed relational data model 

## Features

- Nested JSON structures into relational tables
- Handling of complex one-to-many relationships
- Optimized storage and compute with proper primary and foreign key relationships
- Data quality validation
- Stakeholder discussion

## Getting Started

1. Review the Entity Relationship Diagram (`erd.jpg`) to understand the data model
2. Execute the ingestion scripts in the `data-ingestion` folder to load raw data
3. Run the modeling scripts in the `data-modeling` folder to create structured tables
4. Review the queries in the `questions` folder to get answers about business questions



```bash
├── data-ingestion/              # Raw data files and ingestion scripts
│   ├── brands.json              
│   ├── brands.json.gz           
│   ├── load.sql                 # SQL scripts for data loading
│   ├── receipts.json          
│   ├── receipts.json.gz        
│   ├── users.json          
│   └── users.json.gz          
│
├── data-modeling/               # Data modeling artifacts and scripts for gold layer (production-level data) 
│   ├── brands-gold-table.sql    
│   ├── erd.jpg                  # Entity Relationship Diagram
│   ├── receipts-gold-table.sql  
│   └── user-details-gold-table.sql 
│
├── data-quality-issue/          # Scripts and documentation to identify data quality improvements and issues
│   ├── data-quality.sql         
│   └── task.md               
│
├── questions/                   # Answering business questions leveraging data model
│   ├── questions.sql            
│   └── task.md                
│
└── stakeholder-communication/   # Discussion points with stakeholders
    ├── message.md              
    └── task.md                



