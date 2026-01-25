USE LoanData;
GO

SELECT *
FROM LoanData_staging;

--- CLEANING ---

--1. Remove Duplicates
--2. Standarize the data
--3. Null Values or Blank
--4. Remove any columns
--5. Change data types

--1. Remove Duplicates
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY person_age, person_gender, person_education, person_income, person_emp_exp, person_home_ownership, loan_amnt, loan_intent, loan_int_rate, loan_percent_income, cb_person_cred_hist_length, credit_score, previous_loan_defaults_on_file, loan_status
    ORDER BY person_age
    ) AS row_num
FROM LoanData_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY person_age, person_gender, person_education, person_income, person_emp_exp, person_home_ownership, loan_amnt, loan_intent, loan_int_rate, loan_percent_income, cb_person_cred_hist_length, credit_score, previous_loan_defaults_on_file, loan_status
    ORDER BY person_age
    ) AS row_num
FROM LoanData_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;  --No dusplicates

--2. Standarize the data
SELECT * 
FROM LoanData_staging;

SELECT DISTINCT(person_gender) 
FROM LoanData_staging; --no problems detected

SELECT DISTINCT(person_education) 
FROM LoanData_staging; --no problems detected

SELECT DISTINCT(person_home_ownership) 
FROM LoanData_staging; --no problems detected

SELECT DISTINCT(loan_intent) 
FROM LoanData_staging; --no problems detected

--3. Null Values or Blank
SELECT *
FROM LoanData_staging
WHERE
    person_age IS NULL
    OR person_gender IS NULL
    OR person_education IS NULL
    OR person_income IS NULL
    OR person_emp_exp IS NULL
    OR person_home_ownership IS NULL
    OR loan_amnt IS NULL
    OR loan_intent IS NULL
    OR loan_int_rate IS NULL
    OR loan_percent_income IS NULL
    OR cb_person_cred_hist_length IS NULL
    OR credit_score IS NULL
    OR previous_loan_defaults_on_file IS NULL
    OR loan_status IS NULL;

SELECT *
FROM LoanData_staging
WHERE
    LTRIM(RTRIM(person_age)) = ''
    OR LTRIM(RTRIM(person_gender)) = ''
    OR LTRIM(RTRIM(person_education)) = ''
    OR LTRIM(RTRIM(person_income)) = ''
    OR LTRIM(RTRIM(person_emp_exp)) = ''
    OR LTRIM(RTRIM(person_home_ownership)) = ''
    OR LTRIM(RTRIM(loan_amnt)) = ''
    OR LTRIM(RTRIM(loan_intent)) = ''
    OR LTRIM(RTRIM(loan_int_rate)) = ''
    OR LTRIM(RTRIM(loan_percent_income)) = ''
    OR LTRIM(RTRIM(cb_person_cred_hist_length)) = ''
    OR LTRIM(RTRIM(credit_score)) = ''
    OR LTRIM(RTRIM(previous_loan_defaults_on_file)) = ''
    OR LTRIM(RTRIM(loan_status)) = '';

--4. Remove any columns

--I will use all of them

--5. Change data types
SELECT * 
FROM LoanData_staging;

ALTER TABLE LoanData_staging
ALTER COLUMN person_age INT;

ALTER TABLE LoanData_staging
ALTER COLUMN person_income INT;

ALTER TABLE LoanData_staging
ALTER COLUMN person_emp_exp INT;

ALTER TABLE LoanData_staging
ALTER COLUMN loan_amnt INT;

ALTER TABLE LoanData_staging
ALTER COLUMN loan_int_rate DECIMAL(5,2);

ALTER TABLE LoanData_staging
ALTER COLUMN loan_percent_income DECIMAL(5,2);

ALTER TABLE LoanData_staging
ALTER COLUMN cb_person_cred_hist_length INT;

ALTER TABLE LoanData_staging
ALTER COLUMN credit_score INT;