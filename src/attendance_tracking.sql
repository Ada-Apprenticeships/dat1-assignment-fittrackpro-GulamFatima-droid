-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit

INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (7, 1, DATETIME('now', 'localtime'), DATETIME('now', '+1.5 hours'));


-- 2. Retrieve a member's attendance history
SELECT  strftime('%Y-%m-%d', check_in_time) AS visit_date,  
        strftime('%H:%M:%S', check_in_time) AS check_in_time,
        strftime('%H:%M:%S', check_out_time) AS check_out_time
FROM attendance
WHERE member_id = 5;

-- 3. Find the busiest day of the week based on gym visits

WITH data AS 
(
    SELECT attendance_id,
    CASE strftime('%w', check_in_time)  
        WHEN '0' THEN 'Sunday'  
        WHEN '1' THEN 'Monday'  
        WHEN '2' THEN 'Tuesday'  
        WHEN '3' THEN 'Wednesday'  
        WHEN '4' THEN 'Thursday'  
        WHEN '5' THEN 'Friday'  
        WHEN '6' THEN 'Saturday'  
    END AS day_of_week
    FROM attendance  
)

SELECT day_of_week, COUNT(attendance_id) AS visit_count
FROM data
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;

-- 4. Calculate the average daily attendance for each location

WITH counts AS 
(    
    SELECT     
        location_id,     
        COUNT(DISTINCT strftime('%Y-%m-%d', check_in_time)) AS check_in_dates,    
        COUNT(attendance_id) AS total_attendance    
    FROM attendance 
    GROUP BY location_id    
)

 
SELECT l.name AS location_name, c.total_attendance / c.check_in_dates AS average_daily_attendance  
FROM counts c
LEFT JOIN locations l ON l.location_id = c.location_id  
GROUP BY l.name;
   
    
   
