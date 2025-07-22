-- filepath: /blinkit-sql-analysis/blinkit-sql-analysis/queries/All_Queries.sql
-- Data Cleaning--
SELECT * FROM blinkit_grocery_data;
SET SQL_SAFE_UPDATES = 0;
UPDATE blinkit_grocery_data 
SET Item_Fat_Content = 
CASE 
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END;
SELECT DISTINCT (Item_Fat_Content) FROM blinkit_grocery_data;

-- KPI Requirements--
-- 1. Total_sales by fat content --
SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)) AS TS_mil
FROM blinkit_grocery_data
GROUP BY Item_Fat_Content;

SELECT CAST(SUM(Sales) AS DECIMAL(10,0)) FROM blinkit_grocery_data;

SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_rating FROM blinkit_grocery_data;

SELECT Item_Fat_Content, 
        CONCAT(ROUND(SUM(Sales)/1000, 2), ' k') AS Total_sales_k,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating,
        count(*) as no_of_items
FROM blinkit_grocery_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content
ORDER BY Total_sales_k DESC;

-- 2. Total Sales by item type --
SELECT Item_Type, 
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating,
        count(*) as no_of_items
FROM blinkit_grocery_data
GROUP BY Item_Type
ORDER BY Total_sales DESC
LIMIT 5;

-- 3. Fat content by outlet location for Total sales --
SELECT Outlet_Location_Type, Item_Fat_Content,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating,
        count(*) as no_of_items
FROM blinkit_grocery_data
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Total_sales DESC;

SELECT Outlet_Location_Type, Item_Fat_Content,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales
FROM blinkit_grocery_data
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Total_sales DESC;

SELECT 
    Outlet_Location_Type,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Sales ELSE 0 END), 2) AS Low_Fat,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Sales ELSE 0 END), 2) AS Regular
FROM 
    blinkit_grocery_data
GROUP BY 
    Outlet_Location_Type
ORDER BY 
    Outlet_Location_Type;

SELECT 
    Outlet_Location_Type,
    ROUND(AVG(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Sales ELSE 0 END), 2) AS Low_Fat,
    ROUND(AVG(CASE WHEN Item_Fat_Content = 'Regular' THEN Sales ELSE 0 END), 2) AS Regular
FROM 
    blinkit_grocery_data
GROUP BY 
    Outlet_Location_Type
ORDER BY 
    Outlet_Location_Type;

-- 4. Total Sales by outlet establishment year --   
SELECT Outlet_Establishment_Year,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating,
        count(*) as no_of_items
FROM blinkit_grocery_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_sales DESC;

-- 5. Percentage of sales by outlet size --
SELECT Outlet_Size,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
        CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS sales_percentage
FROM blinkit_grocery_data
GROUP BY Outlet_Size
ORDER BY Total_sales DESC;

SELECT 
    Outlet_Size,
    ROUND(SUM(Sales), 2) AS Total_sales,
    ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (), 2) AS sales_percentage
FROM 
    blinkit_grocery_data
GROUP BY 
    Outlet_Size
ORDER BY 
    Total_sales DESC;

-- 6. Sales by outlet location type --
SELECT Outlet_Location_Type,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
        ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (), 2) AS sales_percentage,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating,
        count(*) as no_of_items
FROM blinkit_grocery_data
GROUP BY Outlet_Location_Type
ORDER BY Total_sales DESC;

-- 7. All metrics by outlet type --
SELECT Outlet_Type,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
        ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (), 2) AS sales_percentage,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating,
        count(*) as no_of_items
FROM blinkit_grocery_data
GROUP BY Outlet_Type
ORDER BY Total_sales DESC;