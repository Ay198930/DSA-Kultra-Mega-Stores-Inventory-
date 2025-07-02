# DSA-Kultra-Mega-Stores-Inventory-
I was tasked with analysing KMS Inventory data using my SQL skills and presenting key insights and findings.

## Kultra Mega Stores Inventory Analysis: Data Cleaning, Analysis, Findings and Recommendations

## 📖 Table of Contents
- [Project Overview](#project-overview)
- [Data Preparation](#data-preparation)
   - [Excel Cleaning](#excel-data-cleaning-steps)
   - [SQL Import](#sql-data-import-process)
- [Analysis Scenarios](#analysis-scenarios)
   - [Case Scenario 1](#case-scenario-1)
   - [Case Scenario 2](#case-scenario-2)
- [Key Insights](#key-insights)
- [Strategic Recommendations](#strategic-recommendations)

   
### Project Overview
The dataset comprises 8,400  products across 21 columns, containing aggregated products, profit margin and shipping information. Before performing any analysis, a  data cleaning process was conducted using Find and Replace in Microsoft Excel, followed by insightful and comprehensive analysis, findings and recommendations using SQL Server Management Studio 20.

**Data Sources:**
The primary data source utilized in this analysis is KMSSQLCaseStudy.csv, an open-source dataset that is freely available for download from platforms such as Kaggle, LMS platform or other public data repositories.

**Tools Used:**
- Microsoft Excel for Data Cleaning  [Download Here](https://www.microsoft.com/en-us/microsoft-365/download-office) 
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
### 1) Which product category had the highest sales?
    SELECT TOP 1
    Product_Category,
    SUM(Sales) as Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Product_Category
	ORDER BY 
    Total_Sales DESC;


### 2) What are the Top 3 and Bottom 3 regions in terms of sales
	- TOP 3
	SELECT TOP 3
    Region,
    SUM(Sales) as Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Region
	ORDER BY 
    Total_Sales DESC;

    - BOTTOM 3
    SELECT TOP 3
    Region,
    SUM(Sales) as Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Region
	ORDER BY 
    Total_Sales ASC;
    
### 3) What were the total Sales of appliances in Ontario?
	SELECT 
    SUM(Sales) AS Total_Sales
	FROM
    KMS_Orders
	WHERE 
    Product_Sub_Category = 'Appliances'
    AND Province = 'Ontario';

### 4) Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers
	Select * from KMS_Orders
	SELECT TOP 10
    Customer_Name,
    SUM(Sales) AS Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Customer_Name
	ORDER BY 
    Total_Sales ASC;
    
**Recommendations**
- Create targeted promotions for these customers
- Implement a customer win-back campaign
- Analyse purchase patterns for upsell opportunities
- Improve customer service engagement
- Offer bundled products at discounted rates

### 5) KMS incurred the most shipping cost using which shipping method?
	SELECT TOP 1
    Ship_Mode,
    SUM(Shipping_Cost) AS Total_Shipping_Cost
	FROM 
    KMS_Orders
	GROUP BY 
    Ship_Mode
	ORDER BY 
    Total_Shipping_Cost DESC;

### Case Scenario II
### 6) Who are the most valuable customers, and what products or services do they typically purchase?
	SELECT TOP 5
    Customer_Name,
    Customer_Segment,
    SUM(Sales) AS Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Customer_Name, Customer_Segment
	ORDER BY 
    Total_Sales DESC;

	- Their purchases
	WITH Top_Customers AS (
    SELECT TOP 5 Customer_Name
    FROM KMS_Orders
    GROUP BY Customer_Name
    ORDER BY SUM(Sales) DESC
    	)
	SELECT 
	o.Customer_Name,
   	 o.Product_Category,
   	 o.Product_Sub_Category,
    	COUNT(*) AS Purchase_Count
	FROM 
    KMS_Orders o
    INNER JOIN Top_Customers tc ON o.Customer_Name = tc.Customer_Name
	GROUP BY 
    o.Customer_Name, o.Product_Category, o.Product_Sub_Category
	ORDER BY 
    o.Customer_Name, Purchase_Count DESC;

	- OR
	SELECT 
    Customer_Name,
    Product_Category,
    Product_Sub_Category,
    COUNT(*) AS Purchase_Count
	FROM 
    KMS_Orders
	WHERE 
    Customer_Name IN (
        SELECT TOP 5 Customer_Name 
        FROM KMS_Orders 
        GROUP BY Customer_Name 
        ORDER BY SUM(Sales) DESC
   	 )
	GROUP BY 
    	Customer_Name, Product_Category, Product_Sub_Category
	ORDER BY 
    Customer_Name, Purchase_Count DESC;

### 7) Which small business customer had the highest sales?
	Select * from KMS_Orders
	SELECT TOP 1
    Customer_Name, Customer_Segment,
    SUM(Sales) AS Total_Sales
	FROM 
    KMS_Orders
	WHERE 
    Customer_Segment = 'Small Business'
	GROUP BY 
    Customer_Name, Customer_Segment
	ORDER BY 
    Total_Sales DESC;

### 8) Which Corporate Customer placed the most number of orders in 2009 – 2012?
	SELECT TOP 1
    Customer_Name,Customer_Segment,
    COUNT(DISTINCT Order_ID) AS Order_Count
	FROM 
    KMS_Orders
	WHERE 
    Customer_Segment = 'Corporate'
    AND Order_Date BETWEEN '2009-01-01' AND '2012-12-31'
	GROUP BY 
    Customer_Name, Customer_Segment
	ORDER BY 
    Order_Count DESC;

### 9) Which consumer customer was the most profitable one?
	SELECT TOP 1
    Customer_Name, Customer_Segment,
    SUM(Profit) AS Total_Profit
	FROM 
    KMS_Orders
	WHERE 
    Customer_Segment = 'Consumer'
	GROUP BY 
    Customer_Name, Customer_Segment
	ORDER BY 
    Total_Profit DESC;

### 10) Which customer returned items, and what segment do they belong to?
	SELECT 
    Customer_Name,
    Customer_Segment,
    COUNT(*) AS Return_Count,
    SUM(Profit) AS Total_Return_Amount
	FROM 
    KMS_Orders
	WHERE 
    Profit < 0
	GROUP BY 
    Customer_Name, Customer_Segment
	ORDER BY 
    Total_Return_Amount ASC;

### 11) If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer!
	SELECT 
    Order_Priority,
    Ship_Mode,
    COUNT(*) AS Order_Count,
    SUM(Shipping_Cost) AS Total_Shipping_Cost,
    AVG(Shipping_Cost) AS Avg_Shipping_Cost,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Order_Priority) AS DECIMAL(5,1)) AS Percentage
	FROM 
    KMS_Orders
	GROUP BY 
    Order_Priority, Ship_Mode
	ORDER BY 
    Order_Priority, Total_Shipping_Cost DESC;
    
**Findings:**
- Critical Orders (Should use fastest method):
	- 35.9% used Delivery Truck (slowest)
	- 15.4% used Express Air (fastest)
	- 48.7% used Regular Air (medium speed)
- High Priority Orders:
	- 31.2% used Delivery Truck
	- 12.1% used Express Air
	- 56.7% used Regular Air
- Low Priority Orders (Should use most economical):
  	-36.4% used Delivery Truck (correct)
  	- 9.1% used Express Air (wasteful)
  	- 54.5% used Regular Air

# Findings and Recommendations for KMS Inventory Analysis

## Key Findings

### Sales Performance
1. **Technology products** generate the highest sales ($1.09M), followed by Furniture and Office Supplies
2. **Northwest Territories** is the top-performing region, while Atlantic region performs the weakest
3. **Grant Carroll** (Small Business segment) is the highest-spending customer ($89,375)
4. **Edward Hooks** (Consumer segment) is the most profitable customer ($4,057 profit)

### Shipping Analysis
1. **Delivery Truck** accounts for the highest shipping costs ($10,591) despite being the slowest method
2. Critical orders frequently use Delivery Truck (35.9%) rather than faster Express Air (15.4%)
3. Shipping method selection doesn't optimally align with order priorities

### Customer Insights
1. **Corporate customers** place the most orders (Carlos Daly with 8 orders)
2. Several customers show **negative profits** indicating returns, led by Jim Radford (Corporate)
3. Bottom 10 customers contribute minimally to overall revenue

## Strategic Recommendations

### 1. Product Strategy
- **Expand high-performing Technology category** with complementary products
- **Bundle slow-moving items** with popular Technology products to boost sales
- **Analyze Furniture subcategories** to replicate success in other regions

### 2. Shipping Optimization
- **Implement priority-based shipping rules**:
  - Critical orders → Express Air (fastest)
  - High orders → Regular Air
  - Medium/Low orders → Delivery Truck
- **Negotiate better rates** with Express Air providers for frequent shipments
- **Monitor delivery performance** to balance cost and customer satisfaction

### 3. Customer Relationship Management

**For Top Customers:**
- **Develop loyalty programs** for Grant Carroll, Carlos Soltero, Edward Hooks
- **Assign dedicated account managers** to high-value customers
- **Offer exclusive early access** to new Technology products

**For Bottom-Performing Customers:**
- **Conduct win-back campaigns** with personalized offers
- **Implement customer feedback surveys** to understand barriers
- **Create targeted promotions** based on purchase history

**For Customers with Returns:**
- **Improve product descriptions** to set accurate expectations
- **Enhance quality control** for frequently returned items
- **Develop return prevention strategies** through better customer education

### 4. Regional Growth Opportunities
- **Increase marketing efforts** in Atlantic region to match Northwest Territories' performance
- **Analyze regional preferences** to tailor product assortments
- **Consider local promotions** to boost underperforming regions

### 5. Data-Driven Improvements
- **Implement real-time sales dashboards** to monitor these KPIs:
  - Sales by product category/region
  - Shipping cost vs delivery speed
  - Customer profitability
- **Set up automated alerts** for negative profit transactions
- **Conduct quarterly reviews** of customer segmentation





