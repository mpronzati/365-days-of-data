USE CustomerChurn;
GO

SELECT * FROM CustomerChurn_staging;

--What is the customer distribution by country?
SELECT
    country,
    COUNT(*) AS CustomersByCountry,
    ROUND(
        1.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        4
    ) AS PercByCountry
FROM CustomerChurn_staging
GROUP BY country
ORDER BY CustomersByCountry DESC;

--What is the average, minimum, and maximum age of customers?
SELECT MIN(age) AS MinAge,
MAX(age) AS MaxAge,
AVG(age) AS AverageAge
FROM CustomerChurn_staging;

--What is the average balance for churned vs retained customers?

SELECT churn,
AVG(balance) AS AverageBalance
FROM CustomerChurn_staging
GROUP BY churn;

--How many products do customers typically have?

SELECT country,
ROUND(AVG(products_number),2) AS AverageProducts
FROM CustomerChurn_staging
GROUP BY country;

SELECT credit_risk_segment,
ROUND(AVG(products_number),2) AS AverageProducts
FROM CustomerChurn_staging
GROUP BY credit_risk_segment;

--Can you categorize the customers by credit Score?
SELECT
    customer_id,
    CAST(credit_score AS INT) AS credit_score,
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        WHEN CAST(credit_score AS INT) >= 670 THEN 'Low Risk'
        ELSE 'Unknown'
    END AS credit_risk_segment
FROM CustomerChurn_staging;

SELECT
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        WHEN CAST(credit_score AS INT) >= 670 THEN 'Low Risk'
        ELSE 'Unknown'
    END AS credit_risk_segment,
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(
        1.0 * SUM(CAST(churn AS INT)) / COUNT(*),
        3
    ) AS churn_rate
FROM CustomerChurn_staging
GROUP BY
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        WHEN CAST(credit_score AS INT) >= 670 THEN 'Low Risk'
        ELSE 'Unknown'
    END;

--Churn Rate by Country
SELECT
    country,
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(
        1.0 * SUM(CAST(churn AS INT)) / COUNT(*),
        4
    ) AS churn_rate
FROM CustomerChurn_staging
GROUP BY country
ORDER BY churn_rate DESC;

--Churn Rate by Active Member Status
SELECT
    active_member,
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(
        1.0 * SUM(CAST(churn AS INT)) / COUNT(*),
        4
    ) AS churn_rate
FROM CustomerChurn_staging
GROUP BY active_member
ORDER BY churn_rate DESC;


--What is the overall customer churn rate?
SELECT
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(
        1.0 * SUM(CAST(churn AS INT)) / COUNT(*),
        4
    ) AS churn_rate
FROM CustomerChurn_staging;

--Which customer segments are more likely to churn?
SELECT
    CASE
        WHEN CAST(age AS INT) < 30 THEN 'Under 30'
        WHEN CAST(age AS INT) BETWEEN 30 AND 44 THEN '30–44'
        WHEN CAST(age AS INT) BETWEEN 45 AND 59 THEN '45–59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
GROUP BY
    CASE
        WHEN CAST(age AS INT) < 30 THEN 'Under 30'
        WHEN CAST(age AS INT) BETWEEN 30 AND 44 THEN '30–44'
        WHEN CAST(age AS INT) BETWEEN 45 AND 59 THEN '45–59'
        ELSE '60+'
    END
ORDER BY churn_rate DESC;

--How do financial indicators such as balance and credit score relate to churn?
SELECT
    CASE
        WHEN CAST(balance AS FLOAT) = 0 THEN 'Zero Balance'
        WHEN CAST(balance AS FLOAT) BETWEEN 0.01 AND 50000 THEN 'Low Balance'
        WHEN CAST(balance AS FLOAT) BETWEEN 50000.01 AND 150000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS balance_segment,
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
GROUP BY
    CASE
        WHEN CAST(balance AS FLOAT) = 0 THEN 'Zero Balance'
        WHEN CAST(balance AS FLOAT) BETWEEN 0.01 AND 50000 THEN 'Low Balance'
        WHEN CAST(balance AS FLOAT) BETWEEN 50000.01 AND 150000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END
ORDER BY churn_rate DESC;

SELECT
    CASE
        WHEN CAST(balance AS FLOAT) = 0 THEN 'Zero Balance'
        WHEN CAST(balance AS FLOAT) BETWEEN 0.01 AND 50000 THEN 'Low Balance'
        ELSE 'High Balance'
    END AS balance_segment,
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS credit_risk_segment,
    COUNT(*) AS total_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
GROUP BY
    CASE
        WHEN CAST(balance AS FLOAT) = 0 THEN 'Zero Balance'
        WHEN CAST(balance AS FLOAT) BETWEEN 0.01 AND 50000 THEN 'Low Balance'
        ELSE 'High Balance'
    END,
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END
ORDER BY churn_rate DESC;

--Does product usage and customer activity influence retention?
SELECT
    active_member,
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
GROUP BY active_member
ORDER BY churn_rate DESC;

SELECT
    CAST(products_number AS INT) AS products_number,
    COUNT(*) AS total_customers,
    SUM(CAST(churn AS INT)) AS churned_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
GROUP BY CAST(products_number AS INT)
ORDER BY products_number;

SELECT
    active_member,
    CAST(products_number AS INT) AS products_number,
    COUNT(*) AS total_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
GROUP BY active_member, CAST(products_number AS INT)
ORDER BY churn_rate DESC;

--Which customer profiles represent the highest churn risk?
SELECT
    active_member,
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS credit_risk_segment,
    CASE
        WHEN CAST(balance AS FLOAT) = 0 THEN 'Zero Balance'
        WHEN CAST(balance AS FLOAT) < 50000 THEN 'Low Balance'
        ELSE 'High Balance'
    END AS balance_segment,
    CAST(products_number AS INT) AS products_number,
    COUNT(*) AS total_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
GROUP BY
    active_member,
    CASE
        WHEN CAST(credit_score AS INT) < 580 THEN 'High Risk'
        WHEN CAST(credit_score AS INT) BETWEEN 580 AND 669 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END,
    CASE
        WHEN CAST(balance AS FLOAT) = 0 THEN 'Zero Balance'
        WHEN CAST(balance AS FLOAT) < 50000 THEN 'Low Balance'
        ELSE 'High Balance'
    END,
    CAST(products_number AS INT)
HAVING COUNT(*) >= 50
ORDER BY churn_rate DESC;


SELECT
    COUNT(*) AS total_customers,
    ROUND(1.0 * SUM(CAST(churn AS INT)) / COUNT(*), 4) AS churn_rate
FROM CustomerChurn_staging
WHERE
    active_member = 0
    AND CAST(credit_score AS INT) < 580
    AND CAST(balance AS FLOAT) = 0
    AND CAST(products_number AS INT) = 1;
