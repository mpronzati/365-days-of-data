CREATE DATABASE CustomerChurn;
GO

USE CustomerChurn;
GO

DROP TABLE IF EXISTS CustomerChurn;

CREATE TABLE CustomerChurn (
    customer_id VARCHAR(50) PRIMARY KEY,
    credit_score VARCHAR(255) NOT NULL,
    country VARCHAR(255),
    gender VARCHAR(255),
    age VARCHAR(255),
    tenure VARCHAR(50),
    balance VARCHAR(100),
    products_number VARCHAR(255),
    credit_card VARCHAR(255),
    active_member VARCHAR(255),
    estimated_salary VARCHAR(255),
    churn VARCHAR(255)
);

BULK INSERT [dbo].[CustomerChurn]
FROM 'C:\Temp\BankCustomerChurn\Bank Customer Churn.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    DATAFILETYPE = 'char',
    TABLOCK,
    BATCHSIZE = 50000,
    CODEPAGE = '65001'
);

SELECT * FROM CustomerChurn;

DROP TABLE IF EXISTS CustomerChurn_staging;

SELECT *
INTO CustomerChurn_staging
FROM CustomerChurn;

SELECT * FROM [dbo].[CustomerChurn_staging]

--- CLEANING ---

--1. Remove Duplicates
--2. Standarize the data
--3. Null Values or Blank
--4. Remove any columns

--1. Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY customer_id, credit_score, country, gender, age, tenure, balance, products_number, credit_card, active_member, estimated_salary, churn
    ORDER BY customer_id
    ) AS row_num
FROM CustomerChurn_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY customer_id, credit_score, country, gender, age, tenure, balance, products_number, credit_card, active_member, estimated_salary, churn
    ORDER BY customer_id
    ) AS row_num
FROM CustomerChurn_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1; --0 duplicates hence no need to delete anything

--2. Standarize the data
SELECT * FROM CustomerChurn_staging;

SELECT DISTINCT(country) 
FROM CustomerChurn_staging;

SELECT DISTINCT(gender) 
FROM CustomerChurn_staging;


--3. Null Values or Blank

SELECT * 
FROM CustomerChurn_staging
WHERE gender is NULL;

SELECT *
FROM CustomerChurn_staging
WHERE
    customer_id IS NULL
    OR credit_score IS NULL
    OR country IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR tenure IS NULL
    OR balance IS NULL
    OR products_number IS NULL
    OR credit_card IS NULL
    OR active_member IS NULL
    OR estimated_salary IS NULL
    OR churn IS NULL;

SELECT *
FROM CustomerChurn_staging
WHERE
    LTRIM(RTRIM(country)) = ''
    OR LTRIM(RTRIM(gender)) = ''
    OR LTRIM(RTRIM(credit_card)) = ''
    OR LTRIM(RTRIM(active_member)) = ''
    OR LTRIM(RTRIM(churn)) = '';



--4. Remove any columns

--I will use all of them
--I will add a new column to make a credit score segmentation

ALTER TABLE CustomerChurn_staging
ADD credit_risk_segment VARCHAR(20);

UPDATE CustomerChurn_staging
SET credit_risk_segment =
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        WHEN CAST(credit_score AS INT) >= 670 THEN 'Low Risk'
        ELSE 'Unknown'
    END;

--5. Data types

UPDATE CustomerChurn_staging
SET
credit_score       = TRY_CAST(credit_score AS INT),
age                = TRY_CAST(age AS INT),
tenure             = TRY_CAST(tenure AS INT),
balance             = TRY_CAST(balance AS DECIMAL(18,2)),
products_number     = TRY_CAST(products_number AS INT),
credit_card         = TRY_CAST(credit_card AS BIT),
active_member       = TRY_CAST(active_member AS BIT),
estimated_salary    = TRY_CAST(estimated_salary AS DECIMAL(18,2)),
churn               = TRY_CAST(churn AS BIT);

ALTER TABLE CustomerChurn_staging
ALTER COLUMN credit_score INT;

ALTER TABLE CustomerChurn_staging
ALTER COLUMN age INT;

ALTER TABLE CustomerChurn_staging
ALTER COLUMN tenure INT;

ALTER TABLE CustomerChurn_staging
ALTER COLUMN balance DECIMAL(18,2);

ALTER TABLE CustomerChurn_staging
ALTER COLUMN products_number INT;

ALTER TABLE CustomerChurn_staging
ALTER COLUMN credit_card BIT;

ALTER TABLE CustomerChurn_staging
ALTER COLUMN active_member BIT;

ALTER TABLE CustomerChurn_staging
ALTER COLUMN estimated_salary DECIMAL(18,2);

ALTER TABLE CustomerChurn_staging
ALTER COLUMN churn BIT;

SELECT * FROM CustomerChurn_staging;