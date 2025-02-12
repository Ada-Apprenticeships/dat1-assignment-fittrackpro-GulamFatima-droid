-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Equipment Management Queries

-- 1. Find equipment due for maintenance

SELECT equipment_id, name, next_maintenance_date
FROM equipment
WHERE timediff('now', next_maintenance_date) LIKE '-0000-00-%';

-- 2. Count equipment types in stock

SELECT type, COUNT(*) AS count  
FROM equipment  
GROUP BY type;  

-- 3. Calculate average age of equipment by type (in days)

WITH data AS 
(
        SELECT type, JULIANDAY(DATE('now')) - JULIANDAY(purchase_date) AS daysDiff
        FROM equipment
)

SELECT DISTINCT type, AVG(daysDiff) AS avg_age_days
FROM data
GROUP BY type;
