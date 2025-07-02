# DSA-Kultra-Mega-Stores-Inventory-
I was tasked with analysing KMS Inventory data using my SQL skills and presenting key insights and findings.

## Kultra Mega Stores Inventory Analysis: Data Cleaning, Analysis, Findings and Recommendations

### Project Overview
The dataset comprises 8,400  products across 21 columns, containing aggregated products, profit margin and shipping information. Before performing any analysis, a  data cleaning process was conducted using Find and Replace in Microsoft Excel, followed by insightful and comprehensive analysis, findings and recommendations using SQL Server Management Studio 20.

**Data Sources:**
The primary data source utilized in this analysis is KMSSQLCaseStudy.csv, an open-source dataset that is freely available for download from platforms such as Kaggle, LMS platform or other public data repositories.

**Tools Used:**
- Microsoft Excel for Data Cleaning  Download Here
- SQL Server Management Studio 20 for cleaning and analysis

## Step 1: Data Cleaning Using Microsoft Excel
### 1. Clean Your CSV File Before Import
      - Open your CSV file in Excel
      - Use Find/Replace (Ctrl+H) to:
      - Find what: empty cells
      - Replace with: `0`
      - Click "Replace All"

### 2. Adjustment of Profit & Unit Price
      - Highlight all columns in profit and unit price
      - Click on the Home tab in your menu bar 
      - Go to Number and increase the indent twice to increase the decimal point. This adjusts all numbers that are not on the decimal point. 

## Step 2. Data Cleaning and Analysis Using SQL Server Management Studio 20(Microsoft SQL Server
### 1. Using your import data to load your data into SQL Server Management Studio 20(Microsoft SQL Server)
      - Open SQL Server Management Studio and connect to your database server
      - Right-click your target database in Object Explorer
      - Select Tasks > Import Data... (Your data here is KMSSQLCaseStudy.csv )
      - In the wizard:
            - Choose Flat File Source as the data source
            - Browse and select your CSV file (KMSSQLCaseStudy.csv)
            - In the  New table name box option, name your file as KMS_Orders (This will serve as the name of our table that will be used for the analysis)
            - Configure format options (delimiter, text qualifier, etc.)
            - Preview the data to verify that it looks correct
      - Click Next and select SQL Server Native Client as the destination
      - Click Finish to execute the import
      - Refresh your database to ensure that the new table has been imported

### 2. Table alterations to standardize data types
      ALTER TABLE KMS_Orders ALTER COLUMN Sales DECIMAL(10,3);
      ALTER TABLE KMS_Orders ALTER COLUMN Profit DECIMAL(10,3);
      ALTER TABLE KMS_Orders ALTER COLUMN Discount DECIMAL(10,3);
      ALTER TABLE KMS_Orders ALTER COLUMN Unit_Price DECIMAL(10,3);
      ALTER TABLE KMS_Orders ALTER COLUMN Shipping_Cost DECIMAL(10,3);

### 3. Analysis using SQL Server Management Studio 20(Microsoft SQL Server
### A. Case Scenario 1
## 1) Which product category had the highest sales?
      SELECT TOP 1
      Product_Category,
      SUM(Sales) as Total_Sales
	FROM 
      KMS_Orders
	GROUP BY 
      Product_Category
	ORDER BY 
      Total_Sales DESC;

