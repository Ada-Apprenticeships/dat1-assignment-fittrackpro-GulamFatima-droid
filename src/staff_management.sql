-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- 1. List all staff members by role

SELECT staff_id, first_name, last_name, position AS role
FROM staff;

-- 2. Find trainers with one or more personal training session in the next 30 days

WITH trainers AS 
(
    SELECT staff_id AS trainer_id, first_name AS trainer_name
    FROM staff
    WHERE position = 'Trainer'
),
counts AS
(
    SELECT trainer_id, trainer_name, COUNT(*) AS session_count
    FROM personal_training_sessions, trainers
    WHERE personal_training_sessions.staff_id = trainers.trainer_id 
    AND session_date BETWEEN DATE('now') AND DATE('now', '+1 month')
    GROUP BY trainer_id
)

SELECT * FROM counts;
