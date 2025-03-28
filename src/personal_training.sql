-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer

SELECT p.session_id, 
(
    SELECT m.first_name || ' ' || m.last_name 
    FROM members m 
    WHERE m.member_id = p.member_id
) AS member_name,
p.session_date, p.start_time, p.end_time
FROM staff s 
LEFT JOIN personal_training_sessions p ON p.staff_id = s.staff_id
WHERE s.first_name = 'Ivy' AND s.last_name = 'Irwin';
