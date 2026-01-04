# Dataset 01 – Coffee Shop Transactions

## Overview
This project focuses on cleaning, transforming, and visualizing coffee shop transaction data.
End-to-end data analytics project using SQL, Python, and Power BI.

## Workflow
1. Data cleaning and standardization in SQL Server
2. Data validation and exploratory analysis in SQL
3. Statistical profiling and outlier analysis in Python
4. Visualization and reporting in Power BI

## Tools
- SQL Server
- Python (pandas, matplotlib)
- Power BI

## Questions to Answer
- How many transactions occur per day and per month?
- What is the total revenue over time?
- What are the average transaction values?
- Are there unusual spikes or anomalies in sales?
- Which products or categories generate the most revenue?

## Weekly Plan
- Day 1: Understand data & define questions
- Day 2: SQL data cleaning
- Day 3: SQL EDA
- Day 4: Python Data Profiling
- Day 5: Python EDA
- Day 6: Power BI Star Schema Definition / Measures
- Day 7: Data visualization & Answer the questions proposed

## Day 1 – Data Understanding & Cleaning Strategy

### Dataset Overview
The dataset contains coffee shop transaction records with the following columns:

- **TransactionID**: Unique identifier for each transaction  
- **Item**: Product purchased  
- **Quantity**: Number of units purchased  
- **PricePerUnit**: Price per unit of the item  
- **TotalSpent**: Total transaction value  
- **PaymentMethod**: Payment type used (cash, card, etc.)  
- **Location**: Store location  
- **TransactionDate**: Date of the transaction  

### Data Quality Issues Identified
The dataset requires significant cleaning due to:
- Missing values (NULLs)
- Invalid values such as `ERROR` and `UNKNOWN`
- Inconsistent or incomplete transactional information

### Cleaning Strategy
The following approach will be used to handle missing and invalid values:

- **Item column**:  
  Missing item names will be inferred using a self-join strategy, identifying items based on matching `PricePerUnit` values across transactions.

- **Quantity, PricePerUnit, TotalSpent**:  
  Missing values will be recalculated using basic arithmetic relationships:
  - `TotalSpent = Quantity × PricePerUnit`
  - `Quantity = TotalSpent / PricePerUnit`
  - `PricePerUnit = TotalSpent / Quantity`

- **Invalid values (`ERROR`, `UNKNOWN`)**:  
  These values will be treated as missing data and handled using the same inference or calculation logic where possible.

This strategy ensures data consistency while minimizing unnecessary data loss.

