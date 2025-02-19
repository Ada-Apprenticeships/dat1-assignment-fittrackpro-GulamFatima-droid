-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership

INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (11, 50.00, DATETIME('now', 'localtime'), 'Credit Card', 'Monthly membership fee');


-- 2. Calculate total revenue from membership fees for each month of the last year

--!!! In order to get a result for all the months this is the only way I can display the columns and it's not possible 
--to show 2 separate columns named month and total revenue however the information requested is still displayed!!!

SELECT 
    SUM(CASE WHEN strftime('%m', payment_date)= '01' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS January,
    SUM(CASE WHEN strftime('%m', payment_date)= '02' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS February,
    SUM(CASE WHEN strftime('%m', payment_date)= '03' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS March,
    SUM(CASE WHEN strftime('%m', payment_date)= '04' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS April,
    SUM(CASE WHEN strftime('%m', payment_date)= '05' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS May,
    SUM(CASE WHEN strftime('%m', payment_date)= '06' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS June,
    SUM(CASE WHEN strftime('%m', payment_date)= '07' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS July,
    SUM(CASE WHEN strftime('%m', payment_date)= '08' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS August,
    SUM(CASE WHEN strftime('%m', payment_date)= '09' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS September,
    SUM(CASE WHEN strftime('%m', payment_date)= '10' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS October,
    SUM(CASE WHEN strftime('%m', payment_date)= '11' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS November,
    SUM(CASE WHEN strftime('%m', payment_date)= '12' AND strftime('%Y', payment_date) = strftime('%Y', DATE('now', '-1 year')) THEN amount ELSE 0 END) AS December         
from payments;


-- 3. Find all day pass purchases

SELECT payment_id, amount, payment_date, payment_method
FROM payments
WHERE payment_type = 'Day pass';