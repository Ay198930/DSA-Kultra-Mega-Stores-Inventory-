Select * from KMS_Orders

----alter table
alter table KMS_Orders
alter column Sales decimal (10,3)

alter table KMS_Orders
alter column Profit decimal (10,3)

alter table KMS_Orders
alter column Discount decimal (10,3)

alter table KMS_Orders
alter column Unit_Price decimal (10,3)

alter table KMS_Orders
alter column shipping_cost decimal (10,3)

----Case Scenario 1
----1) Which product category had the highest sales?
	SELECT TOP 1
    Product_Category,
    SUM(Sales) as Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Product_Category
	ORDER BY 
    Total_Sales DESC;

---2) What are the Top 3 and Bottom 3 regions in terms of sales
	SELECT TOP 3
    Region,
    SUM(Sales) as Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Region
	ORDER BY 
    Total_Sales DESC;

	SELECT TOP 3
    Region,
    SUM(Sales) as Total_Sales
	FROM 
    KMS_Orders
	GROUP BY 
    Region
	ORDER BY 
    Total_Sales ASC;

	---3) What were the total Sales of appliances in Ontario?
	SELECT 
    SUM(Sales) AS Total_Sales
	FROM
    KMS_Orders
	WHERE 
    Product_Sub_Category = 'Appliances'
    AND Province = 'Ontario';

---4) Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers
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
---Recommendations:
--Create targeted promotions for these customers
--Implement a customer win-back campaign
--Analyze purchase patterns for upsell opportunities
--Improve customer service engagement
--Offer bundled products at discounted rates

----5) KMS incurred the most shipping cost using which shipping method?
	SELECT TOP 1
    Ship_Mode,
    SUM(Shipping_Cost) AS Total_Shipping_Cost
	FROM 
    KMS_Orders
	GROUP BY 
    Ship_Mode
	ORDER BY 
    Total_Shipping_Cost DESC;

----Case Scenario II
---6) Who are the most valuable customers, and what products or services do they typically purchase?
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

	----Their purchases
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

	-----OR
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

	---7) Which small business customer had the highest sales?
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

---8) Which Corporate Customer placed the most number of orders in 2009 – 2012?
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

---9) Which consumer customer was the most profitable one?
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

---10) Which customer returned items, and what segment do they belong to?
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

---11) If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer
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