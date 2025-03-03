# Data Modeling Project

This repository contains data modeling, ingestion, and analysis work for structuring and optimizing schema design for nested JSON data.


![erd](https://github.com/user-attachments/assets/38cd8179-9135-48ce-94f1-eda115621c61)


## Repository Structure

```bash
├── data-ingestion/              # Raw data files and ingestion scripts
│   ├── brands.json              # Brand data in JSON format
│   ├── brands.json.gz           # Compressed brand data
│   ├── load.sql                 # SQL scripts for data loading
│   ├── receipts.json            # Receipt data in JSON format
│   ├── receipts.json.gz         # Compressed receipt data
│   ├── users.json               # User data in JSON format
│   └── users.json.gz            # Compressed user data
│
├── data-modeling/               # Data modeling artifacts and scripts
│   ├── brands-gold-table.sql    # SQL for creating gold-level brand tables
│   ├── erd.jpg                  # Entity Relationship Diagram
│   ├── receipts-gold-table.sql  # SQL for creating gold-level receipt tables
│   └── user-details-gold-table.sql # SQL for creating gold-level user tables
│
├── data-quality-issue/          # Scripts and documentation for data quality checks
│   ├── data-quality.sql         # SQL queries for data quality verification
│   └── task.txt                 # Documentation of data quality tasks
│
├── questions/                   # Analytical questions and queries
│   ├── questions.sql            # SQL queries for business analytics
│   └── task.txt                 # Documentation of analytical tasks
│
└── stakeholder-communication/   # Communication artifacts for project stakeholders
    ├── message.md               # Messages for stakeholder communication
    └── task.txt                 # Documentation of communication tasks
