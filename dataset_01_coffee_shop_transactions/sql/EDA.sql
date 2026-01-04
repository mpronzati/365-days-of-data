USE CoffeeSales;
GO

SELECT * FROM [dbo].[Retail_Transactions_staging]

--What are the average transaction values?
SELECT
    AVG(TRY_CAST(PricePerUnit AS DECIMAL(10,2))) AS Avg_PricePerUnit
FROM Retail_Transactions_staging
WHERE TRY_CAST(PricePerUnit AS DECIMAL(10,2)) IS NOT NULL;

--Which products or categories generate the most revenue?
SELECT Item,
SUM(TRY_CAST(TotalSpent AS DECIMAL(10,2))) AS RevenuePerItem
FROM Retail_Transactions_staging
GROUP BY Item
ORDER BY RevenuePerItem DESC;

--Which payment method generate the most revenue?
SELECT PaymentMethod,
SUM(TRY_CAST(TotalSpent AS DECIMAL(10,2))) AS RevenuePerPM
FROM Retail_Transactions_staging
GROUP BY PaymentMethod
ORDER BY RevenuePerPM DESC;

--Which location generate the most revenue?
SELECT [Location],
SUM(TRY_CAST(TotalSpent AS DECIMAL(10,2))) AS RevenuePerLocation
FROM Retail_Transactions_staging
GROUP BY [Location]
ORDER BY RevenuePerLocation DESC;


--What is the total revenue generated per month?
SELECT DISTINCT TransactionDate
FROM Retail_Transactions_staging
WHERE TRY_CONVERT(date, TransactionDate, 103) IS NULL
  AND TransactionDate IS NOT NULL;

SELECT
    FORMAT(TRY_CONVERT(date, TransactionDate, 103), 'yyyy-MM') AS YearMonth,
    SUM(TRY_CAST(TotalSpent AS DECIMAL(12,2))) AS Monthly_Revenue
FROM Retail_Transactions_staging
WHERE TRY_CONVERT(date, TransactionDate, 103) IS NOT NULL
  AND TRY_CAST(TotalSpent AS DECIMAL(12,2)) IS NOT NULL
GROUP BY FORMAT(TRY_CONVERT(date, TransactionDate, 103), 'yyyy-MM')
ORDER BY YearMonth;






SELECT * FROM Retail_Transactions_staging;
