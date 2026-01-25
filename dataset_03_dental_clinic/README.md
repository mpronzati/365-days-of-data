## Day 1 Overview

On Day 1, the focus was on understanding the raw patient visit dataset and preparing it for further analysis. The data represents dental clinic visits, including patient details, treatments, costs, and payment information. At this stage, all columns were kept as text to simplify data ingestion and initial exploration. The dataset contains 14 columns & 45,000 rows.

### Columns Description

- **Patient ID** – Unique identifier for each patient  
- **Patient Name** – Name of the patient  
- **Gender** – Gender of the patient
- **Age** – Age of the patient  
- **Visit Date** – Date of the clinic visit  
- **Address** – Patient address  
- **Consulted By** – Dentist or doctor consulted  
- **Treatment** – Treatment provided during the visit  
- **Dental Camp** – Indicates if the visit was part of a dental camp  
- **X-Ray Done** – Indicates whether an X-ray was performed  
- **Patient Type** – Type of patient (new or returning)  
- **Treatment Type** – Category of treatment  
- **Treatment Cost** – Cost of the treatment  
- **X-Ray Cost** – Cost of the X-ray  
- **OPD Cost** – Outpatient department charges  
- **Lab Charges** – Laboratory charges
- **Discount** – Discount applied  
- **Total Paid** – Amount paid by the patient  
- **Due** – Outstanding balance  
- **Profit** – Profit from the visit  
- **Payment Method** – Method of payment  
- **Visit Month** – Month of the visit

### Business Questions:
1. How is clinic revenue and profit trending over time?
2. Which treatments and treatment types are the most profitable?
3. How do patient types impact revenue and clinic performance?
4. What is the impact of X-Ray usage and lab charges on profitability?
5. Which payment methods are associated with higher outstanding dues?

## Day 2: SQL Cleaning
### Cleaning stages
- Remove Duplicates -> No duplicates found.
- Standarize the data -> minimal intervention to standarize data.
- Null Values or Blank -> No Null or blank values found.
- Remove any columns -> Address, visit month, and treatment columns removed.
- Data types -> All columns' data types have changed to improve data quality.

## Day 3: Exploratory Data Analysis (EDA) – Key Insights
The exploratory analysis revealed several important patterns in clinic operations and performance:
- The first visit patients show the most profit across different patient types.
- Dr Kajal is the dentist who accumulates more profit with 2,807.47 vs 583.46 profit per visit per dentist.
- There are 24 patients with outstanding balances. The maximum is $9201.00, the minimum is $114.00, and the average across those 24 is $2615.88. The total due is $62,781.
- Ranking top 3 of most total paid treeatment types are (1) Implants (2) Braces (OPD + X-ray).
- RCT, Braces, Implants, and Crowns have the most above-average profit per visit.
- In total, a discount of $48,239.20 has been given to patients.
- December appears to be 4 times within the top 10 ranking as the most profitable days.

## Day 4 & 5: Python
Outliers Detection

## Day 6 & 7: Power BI - Dashboard
Dimension Tables created:
- Date
- Dentist
- Patient
- Payment Method
- Treatment

Measures Created:
- Total Discount
- Total Due
- Total Lab Charges
- Total OPD Cost
- Total Profit
- Total Revenue
- Total Treatment Cost
- Total Visits
- Total X-ray Cost
- Average Discount per visit
- Average profit per visit
- Average revenue per visit
- Discount rate %
- Due rate %
- Profit Margin %
- Profit with X-ray
- Profit without X-ray
- Revenue Per Patient
