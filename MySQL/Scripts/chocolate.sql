-- SELECT THE DB [USING ``(BACK TICK) TO SELECT A BD NAME WITH SPACE IN IT]
USE `awesome chocolates`;

-- SHOW ALL THE TABLES CONTAINED IN THE DB
SHOW TABLES;

-- TABLE INFO
DESC geo;
DESC people;
DESC products;
DESC sales;

-- SHOW ALL CONTENT(*) FROM A TABLE
SELECT * FROM geo;
SELECT * FROM people;
SELECT * FROM products;
SELECT * FROM sales;

-- CALCULATION IN QUERY
SELECT SaleDate, Amount, Boxes, Amount/Boxes AS Amount_per_unit FROM sales;

-- IMPOSING CONDITION ON QUERY
-- WHERE CLAUSE
SELECT * FROM sales
WHERE Amount > 10000;
-- MULTIPLE WHERE CLAUSE
SELECT * FROM sales
WHERE Amount > 10000 AND SaleDate >= '2022-01-01';
-- BETWEEN CLAUSE
-- USING < & > OPERATORS
SELECT * FROM sales
WHERE Boxes > 0 AND Boxes <=50;
-- USING BETWEEN OPERATOR
SELECT * FROM sales
WHERE Boxes BETWEEN 0 AND 50;

-- SORTING (ORDER BY)
-- BY DEFAULT IT IS ASCENDING ORDER 
SELECT * FROM sales
WHERE Amount > 10000
ORDER BY Amount;
-- SORTING BY DESCENDING ORDER
SELECT * FROM sales
WHERE Amount > 10000
ORDER BY Amount DESC;
-- MULTIPLE SORT CONDITION
SELECT * FROM sales
WHERE GeoID = 'G1'
ORDER BY PID, Amount DESC;

-- WORKING WITH DATES
-- YEAR
SELECT SaleDate, Amount FROM sales
WHERE Amount > 10000 AND YEAR(SaleDate) = 2022
ORDER BY Amount DESC;
-- MONTH
SELECT SaleDate, Amount FROM sales
WHERE Amount > 10000 AND MONTH(SaleDate) = 12
ORDER BY Amount DESC;
-- SHOW DATA FOR FRIDAYS USING WEEKDAY [HERE 0-MONDAY, 1-TUESDAY, ... , 6-SUNDAY]
SELECT SaleDate, Amount, Boxes, WEEKDAY(SaleDate) as Day_Of_Week FROM sales
WHERE WEEKDAY(SaleDate) = 4
ORDER BY Amount DESC;
-- OR WE CAN RE USE THE Day_Of_Week COL BUT WE NEED TO USE HAVING INSTEAD OF WHERE CLAUSE
SELECT SaleDate, Amount, Boxes, WEEKDAY(SaleDate) as Day_Of_Week FROM sales
HAVING Day_Of_Week = 4
ORDER BY Amount DESC;

-- CASE OPERATOR AND BRANCHING LOGIC
/* ADD NEW COLUMN AMOUNT CATAGORY AND 
AMOUNT UPTO 1000 HAVING LEVEL OF UNDER 1000
AMOUNT BETWEEN 1000 TO 5000 HAVING LEVEL OF UNDER 5000
AMOUNT BETWEEN 5000 TO 10000 HAVING LEVEL OF UNDER 10000
AMOUNT MORE THAN 10000 HAVING LEVEL OF */
SELECT SaleDate, Amount,
CASE 
WHEN Amount < 1000 THEN 'Under 1K'
WHEN Amount < 5000 THEN 'Under 5K'
WHEN Amount < 10000 THEN 'Under 10K'
ELSE '10K or more'
END AS Amount_Category
FROM sales;

-- CHECKING PEOPLE TABLE
SELECT * FROM people;
-- IMPOSING CONDITION ON QUERY
-- OR CLAUSE
SELECT * FROM people
WHERE Team = 'Delish' OR Team = 'Jucies';
-- IN CLAUSE [CAN SELECT MULTIPLE CONDITION EASILY]
SELECT * FROM people
WHERE Team IN ('Delish','Jucies');

-- PATTERN MATCHING
-- LIKE OPERATOR
-- Salesperson name starts with B
SELECT * FROM people
WHERE salesperson LIKE 'B%';
-- Salesperson name ends with h
SELECT * FROM people
WHERE salesperson LIKE '%H';
-- Salesperson name that has A in it
SELECT * FROM people
WHERE salesperson LIKE '%A%';

-- USING MULTIPLE TABLES
-- JOIN OPERATORS
-- SHOW THE SALES TABLE WITH SALEPERSON NAME(USING INNER JOIN, DEFAULT JOIN)
SELECT p.Salesperson, s.SaleDate, s.Amount 
FROM sales as s
JOIN people AS p
ON p.SPID = s.SPID;
-- NOW WE WANT TO CHECK THE PRODUCT NAME SELLING IN THIS SHIPMENT(USING LEFT JOIN)
SELECT p.Product, s.SaleDate, s.Amount 
FROM sales as s
LEFT JOIN products AS p
ON p.PID = s.PID;
-- JOIN MULTIPLE TABLE (MORE THAN 2)
-- NOW WE WANT PRODUCT NAME AND PERSON NAME
SELECT p.Salesperson, s.SaleDate, s.Amount , pr.Product , p.Team
FROM sales as s
JOIN products AS pr
ON pr.PID = s.PID
JOIN people AS p
ON p.SPID = s.SPID;
-- CONDITIONS WITH JOIN
SELECT p.Salesperson, s.SaleDate, s.Amount , pr.Product , p.Team
FROM sales as s
JOIN products AS pr
ON pr.PID = s.PID
JOIN people AS p
ON p.SPID = s.SPID
WHERE s.Amount < 500 AND p.Team = '';
-- PEOPLE FROM INDIA OR NEW ZEALAND
SELECT * FROM geo;
SELECT p.Salesperson, s.SaleDate, s.Amount , pr.Product , p.Team , g.Geo
FROM sales as s
JOIN products AS pr
ON pr.PID = s.PID
JOIN people AS p
ON p.SPID = s.SPID
JOIN geo AS g
ON g.GeoID = s.GeoID
WHERE Geo = 'India' OR Geo = 'New Zealand'
ORDER BY s.SaleDate;

-- GROUP BY AND AGGREGATE FUNC, CREATING REPPORT BY SQL
-- GROUPBY GIVES A PIVOT REPORT
-- TOTAL AMOUNT FOR EACH GEOGRAPHY
SELECT GeoID, SUM(Amount) AS Total_Amount, 
TRUNCATE(AVG(Amount),2) AS Average_Amount,
SUM(Boxes) AS Total_Boxes
FROM sales
GROUP BY GeoID
ORDER BY GeoID;
-- REPORT
SELECT g.Geo, SUM(s.Amount) AS Total_Amount, 
TRUNCATE(AVG(s.Amount),2) AS Average_Amount,
SUM(s.Boxes) AS Total_Boxes
FROM sales AS s
JOIN geo AS g
ON g.GeoID = s.GeoID
GROUP BY g.Geo
ORDER BY Total_Amount;
-- MULTIPLE GROUP BY
-- GROUP BY Category AND TEAM [<> NOT EQUAL TO]
SELECT pr.Category, p.Team,
SUM(s.Amount) AS Total_Amount, 
SUM(s.Boxes) AS Total_Boxes
FROM sales AS s
JOIN people AS p 
ON p.SPID = s.SPID
JOIN products AS pr
ON pr.PID = s.PID
GROUP BY pr.Category, p.Team
HAVING p.Team <> ''
ORDER BY pr.Category, p.Team;
-- TOP 10 PRODUCTS(LIMIT OPERATION)
SELECT pr.Product, SUM(s.Amount) AS Total_Amount
FROM sales AS s
JOIN products AS pr 
ON pr.PID = s.PID
GROUP BY pr.Product
ORDER BY Total_Amount DESC
LIMIT 10;

-- More Practise
-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
SELECT  s.SaleDate , p.Salesperson , s.Amount, pr.Product, s.Boxes, g.Geo
FROM sales AS s
JOIN people AS p
ON p.SPID = s.SPID
JOIN products AS pr
ON pr.PID = s.PID
JOIN geo AS g
ON g.GeoID = s.GeoID
WHERE Amount > 2000 AND Boxes < 100
ORDER BY s.SaleDate;
-- How many shipments (sales) each of the sales persons had in the month of January 2022?
SELECT p.Salesperson, 
COUNT(*) AS Shipment_Count
FROM sales AS s
JOIN people AS p
ON p.SPID = s.SPID
WHERE MONTH(s.SaleDate) = 1 AND YEAR(s.SaleDate) = 2022
GROUP BY p.Salesperson 
ORDER BY Shipment_Count DESC;
-- Which product sells more boxes? Milk Bars or Eclairs?
SELECT pr.Product, SUM(s.Boxes) AS Total_Boxes
FROM sales AS s
JOIN products AS pr
ON pr.PID = s.PID
GROUP BY pr.Product
HAVING pr.Product IN ('Milk Bars', 'Eclairs')
ORDER BY Total_Boxes DESC;
-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
SELECT pr.Product, SUM(s.Boxes) AS Total_Boxes
FROM sales AS s
JOIN products AS pr
ON pr.PID = s.PID
WHERE MONTH(s.SaleDate)= 2 AND YEAR(s.SaleDate) = 2022 
AND DAY(s.SaleDate) BETWEEN 0 AND 8
GROUP BY pr.Product
HAVING pr.Product IN ('Milk Bars', 'Eclairs')
ORDER BY Total_Boxes DESC;
-- OR
SELECT pr.Product, SUM(s.Boxes) AS Total_Boxes
FROM sales AS s
JOIN products AS pr
ON pr.PID = s.PID
WHERE s.SaleDate BETWEEN '2022-2-1' AND '2022-2-7'
GROUP BY pr.Product
HAVING pr.Product IN ('Milk Bars', 'Eclairs')
ORDER BY Total_Boxes DESC;
-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
SELECT * FROM sales
WHERE Customers < 100 AND Boxes < 100
AND WEEKDAY(SaleDate) = 2;
-- OR 
SELECT SaleDate,Amount,Customers,Boxes ,
CASE 
WHEN WEEKDAY(SaleDate) = 2 THEN 'Wednesday Shipment'
END AS 'W Shipment'
FROM sales
WHERE Customers < 100 AND Boxes < 100;
--  What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
SELECT DISTINCT p.Salesperson
FROM sales AS s
JOIN people AS p
ON p.SPID = s.SPID
WHERE MONTH(s.SaleDate)= 2 AND YEAR(s.SaleDate) = 2022 
AND DAY(s.SaleDate) BETWEEN 0 AND 8;
-- Which salespersons did not make any shipments in the first 7 days of January 2022?
SELECT p.Salesperson
FROM people AS p
WHERE p.SPID NOT IN
(SELECT DISTINCT s.SPID FROM sales AS s WHERE MONTH(s.SaleDate)= 2 AND YEAR(s.SaleDate) = 2022 
AND DAY(s.SaleDate) BETWEEN 0 AND 8);
-- How many times we shipped more than 1,000 boxes in each month?
SELECT MONTH(SaleDate) AS 'Month', YEAR(SaleDate) AS 'Year', 
COUNT(*) AS Shipped_1k_more_Bokes
FROM sales
WHERE Boxes > 1000
GROUP BY MONTH(SaleDate) , YEAR(SaleDate) 
ORDER BY 'Month','Year';