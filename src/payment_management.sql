-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership

INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (11, 50.00, DATETIME('now', 'localtime'), 'Credit Card', 'Monthly membership fee');

-- 2. Calculate total revenue from membership fees for each month of the last year

SELECT strftime('%m', payment_date) AS Month, SUM(amount) AS total_revenue  
FROM payments
WHERE strftime('%Y', payment_date) = '2024'
GROUP BY strftime('%m', payment_date);  

-- 3. Find all day pass purchases
SELECT payment_id, amount, payment_date, payment_method
FROM payments
WHERE payment_type = 'Day pass';