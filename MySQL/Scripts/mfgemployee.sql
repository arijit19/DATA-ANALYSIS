CREATE DATABASE practise;
USE practise;
SELECT * FROM mfgemployee;
SELECT DISTINCT job_title FROM mfgemployee;
SELECT DISTINCT department_name, job_title FROM mfgemployee;
SELECT * FROM mfgemployee WHERE department_name IN ('Executive');
SELECT * FROM mfgemployee WHERE department_name NOT IN ('Executive');
SELECT * FROM mfgemployee WHERE 'orighiredate_key' > ('01/01/1990');
SELECT AVG()
