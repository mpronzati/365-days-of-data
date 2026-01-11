# Bank Customer Churn Analysis

## Project Overview
This project analyzes customer churn for a retail bank using transactional and customer profile data.  
The objective is to identify key factors associated with customer attrition and provide insights that can help improve customer retention strategies.

The project follows an end-to-end data workflow: data cleaning and exploration using SQL, data profiling and analysis using Python, and interactive dashboarding using Power BI.

---

## Dataset
**Bank Customer Churn Dataset** (Kaggle)

The dataset contains approximately 10,000 bank customers with demographic, financial, and behavioral attributes, along with a churn indicator showing whether a customer has exited the bank.

Key features include:
- Customer demographics (age, gender, geography)
- Financial metrics (credit score, balance, estimated salary)
- Product usage (number of products, credit card ownership, activity status)
- Target variable: customer churn (Exited)

---

## Business Questions
- What is the overall customer churn rate?
- Which customer segments are more likely to churn?
- How do financial indicators such as balance and credit score relate to churn?
- Does product usage and customer activity influence retention?
- Which customer profiles represent the highest churn risk?

---

## Tools & Technologies
- **SQL Server** – data ingestion, cleaning, transformation, and exploratory data analysis
- **Python (pandas, numpy, matplotlib)** – data profiling, statistical analysis, and outlier detection
- **Power BI** – interactive dashboard creation and data visualization
- **GitHub** – version control and project documentation

---

## Day 1: Explore document data
The dataset comes from Kaggle and has 10,000 rows and 12 columns. The dataset required minimal data cleaning. No missing or invalid values were identified. The preparation phase focused on column standardization, removal of non-analytical identifiers, and validation of numerical ranges before analysis.

Columns description:
- customer_id -> Index Primary Key.
- credit_score -> risk customer profile, the higher the score, the lower the risk.
- country -> Where is the customer based?
- gender -> Male or Female.
- age -> How old the customer is?
- tenure -> How long the customer has been using the bank?
- balance -> Money the customers have in their accounts.
- products_number -> Number of bank products owned.
- credit_card -> 1 hence Customer owns a CC, 2 hence Customer doesn't own a CC.
- active_member -> Is the customer actively using the bank?
- estimated_salary -> Estimated Annual Income.
- churn -> 1 churned, 0 retained.

## Day 2: SQL Cleaning
The preparation phase focused on column standardization, changing data type, and adding a new column. I added credit risk segmentation during the data preparation phase to ensure consistent definitions across all analyses and visualizations. No deep cleaning was needed.

The Credit risk segmentation was created during the data preparation phase to provide a stable, reusable customer attribute for analysis, visualization, and to avoid repeating logic in DAX. The levels are:

-High Risk (< 580): Indicates poor creditworthiness and higher default risk
-Medium Risk (580–669): Represents fair credit profiles with moderate risk
-Low Risk (≥ 670): Reflects good to excellent credit profiles and lower financial risk

## Day 3: SQL Exploratory Data Analysis (EDA)
Explore customer demographics, financial behavior, engagement, and churn patterns to identify key drivers of customer attrition and inform dashboard design.

## Day 4: Python Data Profiling & Validation
On this day, Python was used not for additional cleaning but to validate the quality of the dataset after completing the SQL cleaning process. I took the already cleaned CSV file from day 2 (SQL cleaning).

Key steps included:
- Verifying data types and missing values to confirm no further cleaning was required
- Generating descriptive statistics for numerical variables (e.g., balance, credit score, estimated salary)
- Performing basic outlier detection using statistical summaries and visual inspections (boxplots and distributions)
- Comparing distributions between churned and non-churned customers

Outcome:
No significant data quality issues or extreme outliers were detected. The dataset was confirmed to be clean, consistent, and suitable for downstream analysis and visualization in Power BI.

Using the IQR method, 10 low-end outliers were detected in the credit score distribution (approximately 350–380). These values were retained, as they fall within a realistic credit score range and may represent genuinely high-risk customers.
