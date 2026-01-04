CREATE DATABASE CoffeeSales;
GO

USE CoffeeSales;
GO

DROP TABLE IF EXISTS Retail_Transactions;

CREATE TABLE Retail_Transactions (
    TransactionID VARCHAR(50) PRIMARY KEY,
    Item VARCHAR(255) NOT NULL,
    Quantity VARCHAR(255),
    PricePerUnit VARCHAR(255),
    TotalSpent VARCHAR(255),
    PaymentMethod VARCHAR(50),
    Location VARCHAR(100),
    TransactionDate VARCHAR(255)
);

BULK INSERT [dbo].[Retail_Transactions]
FROM 'C:\Temp\CoffeeSales\dirty_cafe_sales.csv'
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

SELECT * FROM Retail_Transactions;

DROP TABLE IF EXISTS Retail_Transactions_staging;

SELECT *
INTO Retail_Transactions_staging
FROM Retail_Transactions;

SELECT * FROM [dbo].[Retail_Transactions_staging]

--- CLEANING ---

--1. Remove Duplicates
--2. Standarize the data
--3. Null Values or Blank
--4. Remove any columns

--1. Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY TransactionID, Item, Quantity, PricePerUnit, TotalSpent, PaymentMethod, [Location], TransactionDate
    ORDER BY Item
    ) AS row_num
FROM Retail_Transactions_staging;

WITH duplicate_cte AS
(
    SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY TransactionID, Item, Quantity, PricePerUnit, TotalSpent, PaymentMethod, [Location], TransactionDate
    ORDER BY Item
    ) AS row_num
FROM Retail_Transactions_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1; --0 duplicates hence no need to delete anything

--2. Standarize the data --3. Null Values or Blank

SELECT DISTINCT(Item)
FROM Retail_Transactions_staging
ORDER BY Item;

SELECT *
FROM Retail_Transactions_staging
WHERE Item = '';

SELECT *
FROM Retail_Transactions_staging
WHERE PricePerUnit = '1';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '1' AND Item = '');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '1' 
AND a.Item = ''
AND b.Item = 'Cookie';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '1' AND Item = 'ERROR');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '1' 
AND a.Item = 'ERROR'
AND b.Item = 'Cookie';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '1' AND Item = 'UNKNOWN');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '1' 
AND a.Item = 'UNKNOWN'
AND b.Item = 'Cookie';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '1' AND (Item = 'UNKNOWN' OR Item = 'ERROR' OR Item = ''));

SELECT *
FROM Retail_Transactions_staging
WHERE Item = '';

SELECT *
FROM Retail_Transactions_staging
WHERE PricePerUnit = '2';

-- Unique item with priceperunit = 2 is Coffee Hence--

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '2' AND (Item = 'UNKNOWN' OR Item = 'ERROR' OR Item = ''));

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '2' AND Item = '');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '2' 
AND a.Item = ''
AND b.Item = 'Coffee';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '2' AND Item = 'ERROR');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '2' 
AND a.Item = 'ERROR'
AND b.Item = 'Coffee';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '2' AND Item = 'UNKNOWN');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '2' 
AND a.Item = 'UNKNOWN'
AND b.Item = 'Coffee';

SELECT *
FROM Retail_Transactions_staging
WHERE PricePerUnit = '1.5';

--Price perunit = 1.5 is Tea

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '1.5' AND Item = '');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '1.5' 
AND a.Item = ''
AND b.Item = 'Tea';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '1.5' AND Item = 'ERROR');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '1.5' 
AND a.Item = 'ERROR'
AND b.Item = 'Tea';

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '1.5' AND Item = 'UNKNOWN');

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '1.5' 
AND a.Item = 'UNKNOWN'
AND b.Item = 'Tea';

SELECT *
FROM Retail_Transactions_staging
WHERE Item = '';

SELECT *
FROM Retail_Transactions_staging
WHERE PricePerUnit = '3';

SELECT *
FROM Retail_Transactions_staging
WHERE PricePerUnit = '4';

SELECT *
FROM Retail_Transactions_staging
WHERE PricePerUnit = '5';

--Price perunit = 5 is salad

SELECT *
FROM Retail_Transactions_staging
WHERE (PricePerUnit = '5' AND (Item = 'UNKNOWN' OR Item = 'ERROR' OR Item = ''));

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '5' 
AND a.Item = ''
AND b.Item = 'Salad';

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '5' 
AND a.Item = 'ERROR'
AND b.Item = 'Salad';

UPDATE a 
SET a.Item = b.Item 
FROM Retail_Transactions_staging a 
JOIN Retail_Transactions_staging b 
ON a.PricePerUnit = b.PricePerUnit 
WHERE a.PricePerUnit = '5' 
AND a.Item = 'UNKNOWN'
AND b.Item = 'Salad';

SELECT *
FROM Retail_Transactions_staging
WHERE Item = '';

SELECT Item,
COUNT(*)
FROM Retail_Transactions
GROUP BY item;

SELECT Item,
COUNT(*)
FROM Retail_Transactions_staging
GROUP BY item;

SELECT DISTINCT(PricePerUnit)
FROM Retail_Transactions_staging
ORDER BY PricePerUnit;

--fixing math columns
SELECT *
FROM Retail_Transactions_staging;

SELECT *
FROM Retail_Transactions_staging
WHERE (
        TotalSpent IS NULL
        OR LTRIM(RTRIM(TotalSpent)) = ''
        OR UPPER(TotalSpent) IN ('ERROR', 'UNKNOWN')
      )
  AND Quantity IS NOT NULL
  AND PricePerUnit IS NOT NULL;

UPDATE Retail_Transactions_staging
SET TotalSpent =
    CAST(
        TRY_CAST(Quantity AS DECIMAL(10,2)) *
        TRY_CAST(PricePerUnit AS DECIMAL(10,2))
    AS VARCHAR(50))
WHERE (
        TotalSpent IS NULL
        OR LTRIM(RTRIM(TotalSpent)) = ''
        OR UPPER(TotalSpent) IN ('ERROR', 'UNKNOWN')
      )
  AND TRY_CAST(Quantity AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(PricePerUnit AS DECIMAL(10,2)) IS NOT NULL;

SELECT *
FROM Retail_Transactions_staging;

SELECT *
FROM Retail_Transactions_staging
WHERE (
        Quantity IS NULL
        OR LTRIM(RTRIM(Quantity)) = ''
        OR UPPER(Quantity) IN ('ERROR', 'UNKNOWN')
      )
  AND TRY_CAST(TotalSpent AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(PricePerUnit AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(PricePerUnit AS DECIMAL(10,2)) <> 0;

UPDATE Retail_Transactions_staging
SET Quantity =
    CAST(
        TRY_CAST(TotalSpent AS DECIMAL(10,2)) /
        TRY_CAST(PricePerUnit AS DECIMAL(10,2))
    AS VARCHAR(50))
WHERE (
        Quantity IS NULL
        OR LTRIM(RTRIM(Quantity)) = ''
        OR UPPER(Quantity) IN ('ERROR', 'UNKNOWN')
      )
  AND TRY_CAST(TotalSpent AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(PricePerUnit AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(PricePerUnit AS DECIMAL(10,2)) <> 0;

SELECT *
FROM Retail_Transactions_staging
WHERE (
        PricePerUnit IS NULL
        OR LTRIM(RTRIM(PricePerUnit)) = ''
        OR UPPER(PricePerUnit) IN ('ERROR', 'UNKNOWN')
      )
  AND TRY_CAST(TotalSpent AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(Quantity AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(Quantity AS DECIMAL(10,2)) <> 0;

UPDATE Retail_Transactions_staging
SET PricePerUnit =
    CAST(
        TRY_CAST(TotalSpent AS DECIMAL(10,2)) /
        TRY_CAST(Quantity AS DECIMAL(10,2))
    AS VARCHAR(50))
WHERE (
        PricePerUnit IS NULL
        OR LTRIM(RTRIM(PricePerUnit)) = ''
        OR UPPER(PricePerUnit) IN ('ERROR', 'UNKNOWN')
      )
  AND TRY_CAST(TotalSpent AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(Quantity AS DECIMAL(10,2)) IS NOT NULL
  AND TRY_CAST(Quantity AS DECIMAL(10,2)) <> 0;

SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS MissingPaymentMethod,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS MissingLocation
FROM Retail_Transactions_staging;

SELECT DISTINCT(PaymentMethod)
FROM Retail_Transactions_staging;

-- there is no way to guess the data for the columns location and payment method so...

UPDATE Retail_Transactions_staging
SET PaymentMethod = 'Unknown'
WHERE PaymentMethod IS NULL
   OR LTRIM(RTRIM(PaymentMethod)) = ''
   OR UPPER(PaymentMethod) IN ('ERROR','UNKNOWN');

SELECT DISTINCT([Location])
FROM Retail_Transactions_staging;

UPDATE Retail_Transactions_staging
SET Location = 'Unknown'
WHERE Location IS NULL
   OR LTRIM(RTRIM(Location)) = ''
   OR UPPER(Location) IN ('ERROR','UNKNOWN');

UPDATE Retail_Transactions_staging
SET Location = 'Unknown'
WHERE Item IS NULL
   OR LTRIM(RTRIM(Location)) = ''
   OR UPPER(Location) IN ('ERROR','UNKNOWN');

SELECT
    Item,
    AVG(TRY_CAST(PricePerUnit AS DECIMAL(10,2))) AS Avg_PricePerUnit
FROM Retail_Transactions_staging
WHERE TRY_CAST(PricePerUnit AS DECIMAL(10,2)) IS NOT NULL
GROUP BY Item
ORDER BY Avg_PricePerUnit;

SELECT *
FROM Retail_Transactions_staging;

SELECT *
FROM Retail_Transactions_staging
WHERE (Item = '' OR Item = 'UNKNOWN' OR Item = 'ERROR');

SELECT
    Item AS OldItem,
    PricePerUnit,
    CASE
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 1.0 THEN 'Cookie'
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 1.5 THEN 'Tea'
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 2.0 THEN 'Coffee'
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 5.0 THEN 'Salad'
    END AS NewItem
FROM Retail_Transactions_staging
WHERE (
        Item IS NULL
        OR LTRIM(RTRIM(Item)) = ''
        OR UPPER(Item) IN ('ERROR', 'UNKNOWN')
      )
  AND TRY_CAST(PricePerUnit AS DECIMAL(10,2)) IN (1.0, 1.5, 2.0, 5.0);

UPDATE Retail_Transactions_staging
SET Item =
    CASE
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 1.0 THEN 'Cookie'
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 1.5 THEN 'Tea'
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 2.0 THEN 'Coffee'
        WHEN TRY_CAST(PricePerUnit AS DECIMAL(10,2)) = 5.0 THEN 'Salad'
    END
WHERE (
        Item IS NULL
        OR LTRIM(RTRIM(Item)) = ''
        OR UPPER(Item) IN ('ERROR', 'UNKNOWN')
      )
  AND TRY_CAST(PricePerUnit AS DECIMAL(10,2)) IN (1.0, 1.5, 2.0, 5.0);


SELECT DISTINCT(Item)
FROM Retail_Transactions_staging;

UPDATE Retail_Transactions_staging
SET Item = 'Unknown'
WHERE Item IS NULL
   OR LTRIM(RTRIM(Item)) = ''
   OR UPPER(Item) IN ('ERROR', 'UNKNOWN');

SELECT DISTINCT([Location])
FROM Retail_Transactions_staging;

SELECT DISTINCT(PricePerUnit)
FROM Retail_Transactions_staging;

UPDATE Retail_Transactions_staging
SET PricePerUnit = 'Unknown'
WHERE PricePerUnit IS NULL
   OR LTRIM(RTRIM(PricePerUnit)) = ''
   OR UPPER(PricePerUnit) IN ('ERROR', 'UNKNOWN');

SELECT DISTINCT(Quantity)
FROM Retail_Transactions_staging;

UPDATE Retail_Transactions_staging
SET Quantity = 'Unknown'
WHERE Quantity IS NULL
   OR LTRIM(RTRIM(Quantity)) = ''
   OR UPPER(Quantity) IN ('ERROR', 'UNKNOWN');

SELECT DISTINCT(TotalSpent)
FROM Retail_Transactions_staging;

UPDATE Retail_Transactions_staging
SET TotalSpent = 'Unknown'
WHERE TotalSpent IS NULL
   OR LTRIM(RTRIM(TotalSpent)) = ''
   OR UPPER(TotalSpent) IN ('ERROR', 'UNKNOWN');

UPDATE Retail_Transactions_staging
SET TransactionDate = 'Unknown'
WHERE TransactionDate IS NULL
   OR LTRIM(RTRIM(TransactionDate)) = ''
   OR UPPER(TransactionDate) IN ('ERROR', 'UNKNOWN');

SELECT TransactionDate
FROM Retail_Transactions_staging
WHERE TRY_CONVERT(date, TransactionDate, 101) IS NULL
  AND TransactionDate IS NOT NULL;

--4. Remove any columns - I will keep all of them