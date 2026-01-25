CREATE DATABASE LoanData;
GO

USE LoanData;
GO

DROP TABLE IF EXISTS LoanData;

CREATE TABLE LoanData (
    person_age        VARCHAR(255),
    person_gender     VARCHAR(255),
    person_education  VARCHAR(255),
    person_income     VARCHAR(255),
    person_emp_exp    VARCHAR(255),
    person_home_ownership   VARCHAR(255),
    loan_amnt         VARCHAR(255),
    loan_intent       VARCHAR(255),
    loan_int_rate     VARCHAR(255),
    loan_percent_income   VARCHAR(255),
    cb_person_cred_hist_length   VARCHAR(255),
    credit_score      VARCHAR(255),
    previous_loan_defaults_on_file    VARCHAR(255),
    loan_status       VARCHAR(255)
);

BULK INSERT [dbo].[LoanData]
FROM 'C:\Temp\LoanData\loan_data.csv'
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

SELECT *
FROM LoanData;

-- Create Staging table --
DROP TABLE IF EXISTS LoanData_staging;

SELECT *
INTO LoanData_staging
FROM LoanData;

SELECT * FROM [dbo].[LoanData_staging]