USE DentalClinic;
GO

SELECT *
FROM DentalClinic_staging;

---EDA---

--How are patient visits distributed across patient types and genders?
SELECT patient_type,
SUM(total_paid) AS TotalPaidPatientType
FROM DentalClinic_staging
GROUP BY patient_type
ORDER BY TotalPaidPatientType DESC;

SELECT gender,
SUM(total_paid) AS TotalPaidByGender
FROM DentalClinic_staging
GROUP BY gender
ORDER BY TotalPaidByGender DESC;

--Which dentist is the most profitable one?
SELECT consulted_by,
SUM(total_paid) AS TotalPaidByDentist,
COUNT(*) AS TotalVisits
FROM DentalClinic_staging
GROUP BY consulted_by
ORDER BY TotalPaidByDentist DESC;

--Show me all the patients with outstanding balance.
SELECT patient_id,
patient_name,
due
FROM DentalClinic_staging
WHERE due > 0
ORDER BY due DESC;

SELECT COUNT(*) AS TotalPatientsWithDebts
FROM DentalClinic_staging
WHERE due > 0;

SELECT MAX(due) AS MaxDueBalance,
MIN(due) AS MinDueBalance,
AVG(due) AS AverageDueBalance,
SUM(due) AS TotalDue
FROM DentalClinic_staging
WHERE due > 0;

--Rank all treatments to check the most profitable ones
SELECT treatment_type,
SumTotalPaid,
ROW_NUMBER() OVER (ORDER BY SumTotalPaid DESC) AS Rank
FROM (
SELECT
treatment_type,
SUM(total_paid) AS SumTotalPaid
FROM DentalClinic_staging
GROUP BY treatment_type
) t;

--Which treatment types have an above-average profit per visit?
SELECT
treatment_type,
COUNT(*) AS total_visits,
AVG(profit) AS avg_profit_per_visit
FROM DentalClinic_staging
GROUP BY treatment_type
HAVING AVG(profit) >
(
SELECT AVG(profit)
FROM DentalClinic_staging
);

--Identify the patients that got discount the most.
SELECT TOP 10
patient_name,
discount
FROM DentalClinic_staging
ORDER BY discount DESC;

SELECT SUM(discount) AS TotalDiscountGiven
FROM DentalClinic_staging
WHERE discount > 0;

--How are patient visits distributed across revenue quartiles based on total amount paid?
SELECT
revenue_quartile,
COUNT(*) AS number_of_visits,
MIN(total_paid) AS min_total_paid,
MAX(total_paid) AS max_total_paid,
AVG(total_paid) AS avg_total_paid
FROM (
SELECT
total_paid,
NTILE(4) OVER (ORDER BY total_paid) AS revenue_quartile
FROM DentalClinic_staging
WHERE total_paid IS NOT NULL
) q
GROUP BY revenue_quartile
ORDER BY revenue_quartile;

--How is clinic revenue and profit trending over time?
SELECT
visit_date,
daily_profit,
SUM(daily_profit) OVER (
ORDER BY visit_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_total_profit
FROM (
SELECT
visit_date,
SUM(profit) AS daily_profit
FROM DentalClinic_staging
WHERE visit_date IS NOT NULL
GROUP BY visit_date
) d
ORDER BY visit_date; --this one is by date

SELECT
    visit_date,
    profit,
    SUM(profit) OVER (
        ORDER BY visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_profit
FROM DentalClinic_staging
WHERE visit_date IS NOT NULL
ORDER BY visit_date; --this one is by transaction

SELECT
    visit_date,
    total_daily_profit
FROM (
    SELECT
        visit_date,
        SUM(profit) AS total_daily_profit,
        DENSE_RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
    FROM DentalClinic_staging
    WHERE visit_date IS NOT NULL
    GROUP BY visit_date
) t
WHERE profit_rank <= 10
ORDER BY total_daily_profit DESC; --Top 10 most profitable days 

--Which treatment types are the most profitable?
SELECT
    treatment_type,
    SUM(profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM DentalClinic_staging
GROUP BY treatment_type
ORDER BY profit_rank;

--How do patient types impact revenue and clinic performance?
SELECT
patient_type,
COUNT(*) AS total_visits,
SUM(total_paid) AS total_revenue,
SUM(profit) AS total_profit,
AVG(total_paid) AS avg_revenue_per_visit,
AVG(profit) AS avg_profit_per_visit
FROM DentalClinic_staging
GROUP BY patient_type
ORDER BY total_revenue DESC;

--What is the impact of X-Ray usage and lab charges on profitability?
SELECT xray_done,
CASE WHEN lab_charges > 0 THEN 'Lab' ELSE 'No Lab' END AS lab_usage,
COUNT(*) AS total_visits,
SUM(profit) AS total_profit,
AVG(profit) AS avg_profit_per_visit
FROM DentalClinic_staging
GROUP BY xray_done, CASE WHEN lab_charges > 0 THEN 'Lab' ELSE 'No Lab' END
ORDER BY total_profit DESC; --goes through 4 possible scenarios (xray , lab)

--Which payment methods are associated with higher outstanding dues?
SELECT payment_method,
COUNT(*) AS total_visits,
SUM(total_paid) AS total_revenue,
SUM(due) AS total_due,
AVG(due) AS avg_due_per_visit,
CAST(SUM(due) AS DECIMAL(10,2)) / CAST(SUM(total_paid + due) AS DECIMAL(10,2)) * 100 AS pct_outstanding
FROM DentalClinic_staging
GROUP BY payment_method
ORDER BY pct_outstanding DESC;

--How many visits this dental clinic has received by year?
SELECT YEAR(visit_date) AS [Year],
COUNT(*) AS TotalVisits
FROM DentalClinic_staging
GROUP BY YEAR(visit_date)
ORDER BY 2 DESC;

--How many visits this dental clinic has received by month?
SELECT 
MONTH(visit_date) AS [MONTH],
COUNT(*) AS TotalVisits
FROM DentalClinic_staging
WHERE MONTH(visit_date) IS NOT NULL
GROUP BY MONTH(visit_date)
ORDER BY [MONTH];

--Rolling total visits month by month
WITH Rolling_Total AS
(
    SELECT 
        MONTH(visit_date) AS [MONTH],
        COUNT(*) AS TotalVisits
    FROM DentalClinic_staging
    WHERE visit_date IS NOT NULL
    GROUP BY MONTH(visit_date)
)
SELECT 
    [MONTH], 
    TotalVisits,
    SUM(TotalVisits) OVER(ORDER BY [MONTH] ROWS UNBOUNDED PRECEDING) AS rolling_total
FROM Rolling_Total
ORDER BY [MONTH];