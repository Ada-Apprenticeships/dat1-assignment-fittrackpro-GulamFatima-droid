-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships

SELECT m.member_id, m.first_name, m.last_name, me.type, m.join_date
FROM members m
LEFT JOIN memberships me ON m.member_id = me.member_id
WHERE me.status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type

WITH 
startTime AS (  
    SELECT member_id, 
        (strftime('%H', check_in_time) * 60 +  
         strftime('%M', check_in_time) +  
         strftime('%S', check_in_time) / 60) 
         AS startMin  
    FROM attendance  
), 
endTime AS (  
    SELECT member_id, 
        (strftime('%H', check_out_time) * 60 +  
         strftime('%M', check_out_time) +  
         strftime('%S', check_out_time) / 60) 
         AS endMin  
    FROM attendance  
),
timeDiff AS (
    SELECT s.member_id, (e.endMin - s.startMin) AS timeSpent
    FROM startTime s, endTime e
    WHERE e.member_id = s.member_id
),
result AS (
    SELECT t.timeSpent, t.member_id, (SELECT type FROM memberships me WHERE me.member_id = t.member_id) AS type
    FROM timeDiff t
)

SELECT r.type AS membership_type, AVG(r.timeSpent) AS avg_visit_duration_minutes
FROM result r 
GROUP BY r.type;


-- 3. Identify members with expiring memberships this year

SELECT m.member_id, m.first_name, m.last_name, m.email, me.end_date
FROM members m 
LEFT JOIN memberships me ON me.member_id = m.member_id
WHERE strftime('%Y', me.end_date) = strftime('%Y', 'now');