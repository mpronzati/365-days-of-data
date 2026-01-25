USE LoanData;
GO

SELECT *
FROM LoanData_staging;

---EDA---
--How many loan applications are in the dataset?
SELECT COUNT(*) AS QuantityOfLoans
FROM LoanData_staging;

--What is the overall loan approval rate?
SELECT *
FROM LoanData_staging
WHERE loan_status = 1;

SELECT loan_status,
COUNT(*) AS Total,
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM LoanData_staging
GROUP BY loan_status;

--What is the age distribution of applicants?
SELECT
MIN(person_age) AS min_age,
MAX(person_age) AS max_age,
AVG(person_age) AS avg_age
FROM LoanData_staging;

--Approval rate by education level
SELECT
person_education,
ROUND(100.0 * SUM(CASE WHEN loan_status = '1' THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM LoanData_staging
GROUP BY person_education
ORDER BY approval_rate DESC;

--How does credit score impact loan approval?
SELECT
    CASE
        WHEN credit_score < 600 THEN 'Low'
        WHEN credit_score BETWEEN 600 AND 699 THEN 'Medium'
        ELSE 'High'
    END AS credit_score_band,
    COUNT(*) AS applications,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM LoanData_staging
GROUP BY
    CASE
        WHEN credit_score < 600 THEN 'Low'
        WHEN credit_score BETWEEN 600 AND 699 THEN 'Medium'
        ELSE 'High'
    END;

--Average loan amount by approval status
SELECT
    loan_status,
    AVG(loan_amnt) AS avg_loan_amount
FROM LoanData_staging
GROUP BY loan_status;

--Which loan intents have the highest rejection rates?
SELECT
    loan_intent,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS rejection_rate
FROM LoanData_staging
GROUP BY loan_intent
ORDER BY rejection_rate DESC;

--Which customer profiles are most likely to be approved?
SELECT
    person_home_ownership,
    person_education,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM LoanData_staging
GROUP BY person_home_ownership, person_education
ORDER BY approval_rate DESC;

--Correlation between Person_income and Loan_status
SELECT
    income_band,
    COUNT(*) AS applications,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM (
    SELECT
        loan_status,
        CASE
            WHEN person_income < 30000 THEN 'Low income'
            WHEN person_income BETWEEN 30000 AND 59999 THEN 'Middle income'
            WHEN person_income BETWEEN 60000 AND 99999 THEN 'Upper-middle income'
            ELSE 'High income'
        END AS income_band
    FROM LoanData_staging
) t
GROUP BY income_band
ORDER BY approval_rate DESC;

--What is the Loans that has income above average?
SELECT *
FROM LoanData_staging;

SELECT *
FROM LoanData_staging
WHERE person_income >=
(
SELECT 
ROUND(AVG(CAST(person_income AS DECIMAL(18,2))), 2) AS avg_income
FROM LoanData_staging
);

--Which rejected applications actually have an income above the overall average?
SELECT *
FROM LoanData_staging
WHERE loan_status = 0 AND person_income >=
(
SELECT 
ROUND(AVG(CAST(person_income AS DECIMAL(18,2))), 2) AS avg_income
FROM LoanData_staging
);

--Which loans have an interest rate higher than the average interest rate for their loan intent?
SELECT *
FROM LoanData_staging
WHERE loan_int_rate >=
(
SELECT AVG(loan_int_rate) AS AvgIntLoan
FROM LoanData_staging
);

--What are the key factors driving loan approval or rejection?
SELECT *
FROM LoanData_staging;

SELECT loan_status,
ROUND(AVG(CAST(person_income AS DECIMAL(18,2))), 2) AS avg_income,
ROUND(AVG(CAST(loan_amnt AS DECIMAL(18,2))), 2) AS AvgLoanAmount,
ROUND(AVG(CAST(credit_score AS DECIMAL(18,2))), 2) AS avg_credit_score,
ROUND(AVG(CAST(person_age AS DECIMAL(18,2))), 2) AS avg_age
FROM LoanData_staging
GROUP BY loan_status;

SELECT person_education,
COUNT(*) AS total_apps,
AVG(CASE WHEN loan_status = 1 THEN 1.0 ELSE 0 END) AS approval_rate
FROM LoanData_staging
GROUP BY person_education
ORDER BY approval_rate DESC;

SELECT loan_intent,
COUNT(*) AS total_apps,
AVG(CASE WHEN loan_status = 1 THEN 1.0 ELSE 0 END) AS approval_rate
FROM LoanData_staging
GROUP BY loan_intent
ORDER BY approval_rate DESC;

SELECT person_home_ownership,
COUNT(*) AS total_apps,
AVG(CASE WHEN loan_status = 1 THEN 1.0 ELSE 0 END) AS approval_rate
FROM LoanData_staging
GROUP BY person_home_ownership
ORDER BY approval_rate DESC;


--Are there customer segments with high rejection rates that could be improved with policy changes?
SELECT person_education,
FLOOR(credit_score / 50) * 50 AS credit_score_band,
COUNT(*) AS total_apps,
AVG(CASE WHEN loan_status = 0 THEN 1.0 ELSE 0 END) AS rejection_rate
FROM LoanData_staging
GROUP BY person_education, FLOOR(credit_score / 50) * 50
HAVING COUNT(*) >= 30
ORDER BY rejection_rate DESC;

SELECT person_home_ownership,
FLOOR(credit_score / 50) * 50 AS credit_score_band,
COUNT(*) AS total_apps,
AVG(CASE WHEN loan_status = 0 THEN 1.0 ELSE 0 END) AS rejection_rate
FROM LoanData_staging
GROUP BY person_home_ownership, FLOOR(credit_score / 50) * 50
HAVING COUNT(*) >= 30
ORDER BY rejection_rate DESC;

SELECT loan_intent,
COUNT(*) AS total_apps,
AVG(CASE WHEN loan_status = 0 THEN 1.0 ELSE 0 END) AS rejection_rate
FROM LoanData_staging
GROUP BY loan_intent
HAVING COUNT(*) >= 20
ORDER BY rejection_rate DESC;

--What role does credit history play compared to income?
SELECT
loan_status,
ROUND(AVG(CAST(credit_score AS DECIMAL(18,2))), 2) AS avg_credit_score,
ROUND(AVG(CAST(person_income AS DECIMAL(18,2))), 2) AS avg_income
FROM LoanData_staging
GROUP BY loan_status;

--Which Loan applications has been approved after a default on file?
SELECT *
FROM LoanData_staging
WHERE loan_status = 1 AND previous_loan_defaults_on_file = 'YES';

SELECT *
FROM LoanData_staging
WHERE loan_status = 1 AND previous_loan_defaults_on_file = 'NO';

SELECT *
FROM LoanData_staging
WHERE loan_status = 0 AND previous_loan_defaults_on_file = 'YES';

SELECT *
FROM LoanData_staging
WHERE loan_status = 0 AND previous_loan_defaults_on_file = 'NO';

SELECT
loan_status,
previous_loan_defaults_on_file,
COUNT(*) AS total_records
FROM LoanData_staging
GROUP BY loan_status, previous_loan_defaults_on_file
ORDER BY loan_status, previous_loan_defaults_on_file;

SELECT
SUM(CASE WHEN loan_status = 1 AND previous_loan_defaults_on_file = 'YES' THEN 1 ELSE 0 END) AS approved_with_defaults,
SUM(CASE WHEN loan_status = 1 AND previous_loan_defaults_on_file = 'NO'  THEN 1 ELSE 0 END) AS approved_no_defaults,
SUM(CASE WHEN loan_status = 0 AND previous_loan_defaults_on_file = 'YES' THEN 1 ELSE 0 END) AS rejected_with_defaults,
SUM(CASE WHEN loan_status = 0 AND previous_loan_defaults_on_file = 'NO'  THEN 1 ELSE 0 END) AS rejected_no_defaults
FROM LoanData_staging;

SELECT cb_person_cred_hist_length
FROM LoanData_staging
ORDER BY cb_person_cred_hist_length DESC;

--Which Loan applications has been approved with higher credit history lenght?
SELECT
SUM(CASE WHEN loan_status = 1 AND cb_person_cred_hist_length = 2 THEN 1 ELSE 0 END) AS approved_with_low_credithistory,
SUM(CASE WHEN loan_status = 1 AND cb_person_cred_hist_length = 30  THEN 1 ELSE 0 END) AS approved_high_credithistory,
SUM(CASE WHEN loan_status = 0 AND cb_person_cred_hist_length = 2 THEN 1 ELSE 0 END) AS rejected_with_low_credithistory,
SUM(CASE WHEN loan_status = 0 AND cb_person_cred_hist_length = 30  THEN 1 ELSE 0 END) AS rejected_high_credithistory
FROM LoanData_staging;