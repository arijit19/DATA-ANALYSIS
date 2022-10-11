USE Delete_Duplicate_Data;
DROP TABLE IF EXISTS cars;
CREATE TABLE IF NOT EXISTS cars
(
	id INT NOT NULL AUTO_INCREMENT,
    model VARCHAR (50) NOT NULL,
    brand VARCHAR (40) NOT NULL,
    color VARCHAR (30),
    make INT NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO cars (model,brand,color,make)
VALUES('Model S', 'Tesla', 'Blue', 2018),
('EQS', 'Mercedes-Benz', 'Black', 2022),
('iX', 'BMW', 'Red', 2022),
('Ioniq 5', 'Hyundai', 'White', 2021),
('Model S', 'Tesla', 'Silver', 2018),
('Ioniq 5', 'Hyundai', 'Green', 2021);

SELECT * FROM cars;

-- CHECK NUMBER OF OCCURREENCE / CHECK DUPLICATE RECORDS
SELECT model, brand, COUNT(*)
FROM cars
GROUP BY model, brand;
-- PRINT ONLY DUPLICATE RECORDS
SELECT model, brand, COUNT(*) AS Duplicate_Value
FROM cars
GROUP BY model, brand
HAVING Duplicate_Value > 1;
-- PRINT THE ID OF DUPLICATE COLS
SELECT model, brand, MAX(id) AS Duplicate_IDs
FROM cars
GROUP BY model, brand
HAVING COUNT(*) > 1;
-- PRINT USING SELF JOIN
SELECT c2.id
FROM cars AS c1
JOIN cars AS c2
ON c1.model = c2.model AND c1.brand = c2.brand
WHERE c1.id < c2.id;
-- DELETE DUPLICATE VALUES
-- FIRST WE NEED TO CREATE A TEMP DUPLICATE TABLE AS WE CAN NOT DELETE BY SELECTING FROM THE TABLE WE WANT TO DELETE
DROP TABLE IF EXISTS cars_copy;
CREATE TEMPORARY TABLE cars_copy LIKE cars;
INSERT INTO cars_copy SELECT * FROM cars;
-- SAFE UPDATE MODE REQUIRES KEY TO UPDATE/DELETE WITH WHERE CLAUSE [MYSQL WORKBENCH ISSUE]
SET SQL_SAFE_UPDATES=0;
-- DELETE DUPLICATE USING GROUP BY
DELETE FROM cars
WHERE id IN (
	SELECT MAX(id) 
	FROM cars_copy
	GROUP BY model, brand
	HAVING COUNT(*) > 1
    );
-- DELETE DUPLICATE USING ROW_NUMBER FUNC
DELETE FROM cars 
WHERE id IN (
	SELECT id FROM (
		SELECT id, ROW_NUMBER()
		OVER(PARTITION BY model, brand ORDER BY id DESC) AS row_num FROM cars_copy	
	) AS c WHERE row_num >1
);