USE DentalClinic;
GO

SELECT *
FROM DentalClinic_staging;

--- CLEANING ---

--1. Remove Duplicates
--2. Standarize the data
--3. Null Values or Blank
--4. Remove any columns
--5. Change data types

--1. Remove Duplicates
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY patient_id, patient_name, gender, age, visit_date, [address], consulted_by, treatment, dental_camp, xray_done, patient_type, treatment_type, treatment_cost, xray_cost, opd_cost, lab_charges, discount, total_paid, due, profit, payment_method, visit_month
    ORDER BY patient_id
    ) AS row_num
FROM DentalClinic_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY patient_id, patient_name, gender, age, visit_date, [address], consulted_by, treatment, dental_camp, xray_done, patient_type, treatment_type, treatment_cost, xray_cost, opd_cost, lab_charges, discount, total_paid, due, profit, payment_method, visit_month
    ORDER BY patient_id
    ) AS row_num
FROM DentalClinic_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;  --No dusplicates

--2. Standarize the data
SELECT DISTINCT(patient_name) 
FROM DentalClinic_staging; --no problems detected

SELECT DISTINCT(gender) 
FROM DentalClinic_staging; --no problems detected

SELECT DISTINCT([address]) 
FROM DentalClinic_staging; --There is no address values in this column, hence good candidate to be deleted

SELECT DISTINCT(consulted_by) 
FROM DentalClinic_staging;

SELECT DISTINCT(treatment) 
FROM DentalClinic_staging; --OPD + X-ray?

SELECT DISTINCT(dental_camp) 
FROM DentalClinic_staging;

SELECT DISTINCT(xray_done) 
FROM DentalClinic_staging;

SELECT DISTINCT(patient_type) 
FROM DentalClinic_staging;

SELECT DISTINCT(treatment_type) 
FROM DentalClinic_staging;

SELECT patient_id, treatment, treatment_type 
FROM DentalClinic_staging; --columns treatment & treatment_type store the same info.

SELECT DISTINCT(payment_method) 
FROM DentalClinic_staging;

--3. Null Values or Blank
SELECT *
FROM DentalClinic_staging
WHERE
    patient_id IS NULL
    OR patient_name IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR visit_date IS NULL
    OR [address] IS NULL
    OR consulted_by IS NULL
    OR treatment IS NULL
    OR dental_camp IS NULL
    OR xray_done IS NULL
    OR patient_type IS NULL
    OR treatment_type IS NULL
    OR treatment_cost IS NULL
    OR xray_cost IS NULL
    OR opd_cost IS NULL
    OR lab_charges IS NULL
    OR discount IS NULL
    OR total_paid IS NULL
    OR due IS NULL
    OR profit IS NULL
    OR payment_method IS NULL
    OR visit_month IS NULL;

SELECT *
FROM DentalClinic_staging
WHERE
    LTRIM(RTRIM(patient_id)) = ''
    OR LTRIM(RTRIM(patient_name)) = ''
    OR LTRIM(RTRIM(gender)) = ''
    OR LTRIM(RTRIM(age)) = ''
    OR LTRIM(RTRIM(visit_date)) = ''
    OR LTRIM(RTRIM(address)) = ''
    OR LTRIM(RTRIM(consulted_by)) = ''
    OR LTRIM(RTRIM(treatment)) = ''
    OR LTRIM(RTRIM(dental_camp)) = ''
    OR LTRIM(RTRIM(xray_done)) = ''
    OR LTRIM(RTRIM(patient_type)) = ''
    OR LTRIM(RTRIM(treatment_type)) = ''
    OR LTRIM(RTRIM(treatment_cost)) = ''
    OR LTRIM(RTRIM(xray_cost)) = ''
    OR LTRIM(RTRIM(opd_cost)) = ''
    OR LTRIM(RTRIM(lab_charges)) = ''
    OR LTRIM(RTRIM(discount)) = ''
    OR LTRIM(RTRIM(total_paid)) = ''
    OR LTRIM(RTRIM(due)) = ''
    OR LTRIM(RTRIM(profit)) = ''
    OR LTRIM(RTRIM(payment_method)) = ''
    OR LTRIM(RTRIM(visit_month)) = '';

--4. Remove any columns
ALTER TABLE DentalClinic_staging
DROP COLUMN treatment;

ALTER TABLE DentalClinic_staging
DROP COLUMN [address];

ALTER TABLE DentalClinic_staging
DROP COLUMN visit_month; --This column will be deleted and I will create a proper DATE dimension table in Power BI that will replace the functionality

SELECT * FROM DentalClinic_staging;

--5. Change data types
ALTER TABLE DentalClinic_staging
ALTER COLUMN patient_id VARCHAR(255);  -- make sure length fits your data

ALTER TABLE DentalClinic_staging
ALTER COLUMN age INT;

ALTER TABLE DentalClinic_staging
ALTER COLUMN treatment_cost DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN xray_cost DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN opd_cost DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN lab_charges DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN discount DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN total_paid DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN due DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN profit DECIMAL(10,2);

ALTER TABLE DentalClinic_staging
ALTER COLUMN visit_date DATE;

ALTER TABLE DentalClinic_staging
ALTER COLUMN visit_month DATE;

--Handling visit_date
UPDATE DentalClinic_staging
SET visit_date = CONVERT(DATE, visit_date, 103)
WHERE visit_date IS NOT NULL
  AND LTRIM(RTRIM(visit_date)) <> '';

ALTER TABLE DentalClinic_staging
ALTER COLUMN visit_date DATE;
