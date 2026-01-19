CREATE DATABASE DentalClinic;
GO

USE DentalClinic;
GO

DROP TABLE IF EXISTS DentalClinic;

CREATE TABLE DentalClinic (
    patient_id        VARCHAR(255) PRIMARY KEY,
    patient_name      VARCHAR(255),
    gender            VARCHAR(255),
    age               VARCHAR(255),
    visit_date        VARCHAR(255),
    [address]           VARCHAR(255),
    consulted_by      VARCHAR(255),
    treatment         VARCHAR(255),
    dental_camp       VARCHAR(255),
    xray_done         VARCHAR(255),
    patient_type      VARCHAR(255),
    treatment_type    VARCHAR(255),
    treatment_cost    VARCHAR(255),
    xray_cost         VARCHAR(255),
    opd_cost          VARCHAR(255),
    lab_charges       VARCHAR(255),
    discount          VARCHAR(255),
    total_paid        VARCHAR(255),
    due               VARCHAR(255),
    profit            VARCHAR(255),
    payment_method    VARCHAR(255),
    visit_month       VARCHAR(255)
);

BULK INSERT [dbo].[DentalClinic]
FROM 'C:\Temp\DentalClinic\final_data_mldc.csv'
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
FROM DentalClinic;

-- Create Staging table --
DROP TABLE IF EXISTS DentalClinic_staging;

SELECT *
INTO DentalClinic_staging
FROM DentalClinic;

SELECT * FROM [dbo].[DentalClinic_staging]