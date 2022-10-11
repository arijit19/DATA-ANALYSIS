CREATE DATABASE record_company;
USE record_company;

CREATE TABLE singer (
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR (255) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE song (
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR (255) NOT NULL,
release_year INT,
singer_id INT NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (singer_id) REFERENCES singer (id)
);

ALTER TABLE song
ADD album_name VARCHAR (255);

INSERT INTO singer (name)
VALUES ('Arijit Singh'), 
('Shreya Ghosal'), ('Alka Yagnik'),
('Brodha V') , ('KALEO'), ('Hozier');

SELECT * FROM singer;
SELECT * FROM singer LIMIT 2;
SELECT name FROM singer;
SELECT id AS 'Singer_ID', name AS 'Singer_Name' from singer;
SELECT * FROM singer ORDER BY name ASC;
SELECT * FROM singer ORDER BY name DESC;


INSERT INTO song (name, release_year, album_name, singer_id)
VALUE ('Sunn Raha Hai-Rozana', 2017, 'T-Series MixTape', 2),
	  ('Kabhi Jo Badal Barse', 2014, NULL, 1),
      ('Agar Tum Saath Ho', 2015, NULL, 3),
      ('Aathma Raama', 2022, 'Aathma Raama', 4),
      ('Take Me To Church', 2012, NULL, 6),
      ('Way Down We Go', 2015, NULL, 5);
      
SELECT * FROM song;
SELECT name FROM song;

INSERT INTO song (name, release_year, album_name, singer_id)
VALUE ('Agar Tum Saath Ho', 2015, NULL, 1);

/* Distinct return unique values */
SELECT DISTINCT name FROM song;

UPDATE song
SET release_year = 2013 
WHERE id = 5;

SELECT * FROM song
WHERE release_year < 2015;

SELECT * FROM song
WHERE name LIKE '%ra%';

SELECT * FROM song
WHERE name LIKE '%T%' OR singer_id = 2;

SELECT * FROM song
WHERE release_year < 2015 AND singer_id = 1;

SELECT * FROM song
WHERE release_year BETWEEN 2013 AND 2015;

SELECT * FROM song
WHERE album_name IS NULL;

SELECT * FROM song
WHERE album_name IS NOT NULL;

INSERT INTO song (name, release_year, album_name, singer_id)
VALUE ('Test Song', NULL, NULL, 1);

SELECT * FROM song;

DELETE FROM song WHERE id = 9;

/* JOINS */

SELECT * FROM singer
JOIN song ON singer.id = song.singer_id;

INSERT INTO singer (name)
VALUES ('DJ Chakry');

SELECT * FROM singer;

/* INNER JOIN - Gives common elements from both left(singer) table and right(songs) table
 INNER JOIN = JOIN, it is the default join */
 
SELECT * FROM singer
JOIN song ON singer.id = song.singer_id;

SELECT * FROM singer
INNER JOIN song ON singer.id = song.singer_id;

/* TEST --------------------- */
SELECT * FROM song;
SELECT * FROM singer;

INSERT INTO singer (name)
VALUES ('TEST');

INSERT INTO song (name, release_year, album_name, singer_id)
VALUE ('Test Song', NULL, NULL, 9);

DELETE FROM song WHERE id = 14;
DELETE FROM singer WHERE id = 8;

/* LEFT JOIN - Gives all the element of left table and only common elements 
from right table */

SELECT * FROM singer
LEFT JOIN song ON singer.id = song.singer_id;

/* RIGHT JOIN - Gives all the element of right table and only common elements 
from left table */

SELECT * FROM singer
RIGHT JOIN song ON singer.id = song.singer_id;

SELECT * FROM  song
RIGHT JOIN singer ON singer.id = song.singer_id;
/* NATURAL JOIN - columns with the same name of associated tables will appear once only. */
SELECT * FROM song
NATURAL JOIN singer;

/* Aggregate functions ----------------- */

SELECT AVG(release_year) from song;
SELECT SUM(release_year) from song;
SELECT COUNT(release_year) from song;

/* GROUP BY --------------------------- */
SELECT singer_id, COUNT(singer_id) FROM song
GROUP BY singer_id;

SELECT singer_id AS fk_singer_id , ANY_VALUE(s.id) AS singer_id, ANY_VALUE(s.name) AS singer_name, COUNT(m.id) AS num_music
FROM singer AS s
LEFT JOIN song AS m ON s.id = m.singer_id
GROUP BY s.id;

/* WHERE vs HAVING both are same. 
WHERE executes before GROUP BY, But HAVING executes after GROUP BY.
Therefore we use HAVING with GROUP BY. 
EX: num_music can only be accessed after GROUP BY is executed whereas 
song name(s.name) can be accessed before GROUP BY */
 
SELECT singer_id AS fk_singer_id , ANY_VALUE(s.id) AS singer_id, ANY_VALUE(s.name) AS singer_name, COUNT(m.id) AS num_music
FROM singer AS s
LEFT JOIN song AS m ON s.id = m.singer_id
WHERE s.name = 'Brodha V'
GROUP BY s.id
HAVING num_music = 1;

SELECT * FROM song;
SELECT * FROM singer;

/* 

1. ALTER Command:

ALTER SQL command is a DDL (Data Definition Language) statement. ALTER is used to update the structure of the table in the database (like add, delete, modify the attributes of the tables in the database).

Syntax:

// add a column to the existing table

ALTER TABLE tableName

ADD columnName columnDefinition;

 

// drop a column from the existing table

ALTER TABLE tableName

DROP COLUMN columnName;



// rename a column in the existing table

ALTER TABLE tableName

RENAME COLUMN olderName TO newName;



// modify the datatype of an already existing column in the table

ALTER TABLE table_name

ALTER COLUMN column_name column_type;

2. UPDATE Command:

UPDATE SQL command is a DML (Data manipulation Language) statement. It is used to manipulate the data of any existing column. But can’t be change the table’s definition.

Syntax:

// table name that has to update

UPDATE tableName

// which columns have to update

SET column1 = value1, column2 = value2, ...,columnN=valueN.

// which row you have to update

WHERE condition

Note :  Without WHERE clause, all records in the table will be updated.
*/