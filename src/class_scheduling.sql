-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors

SELECT c.class_id, c.name, s.first_name
FROM classes c 
LEFT JOIN class_schedule cs, staff s
ON cs.class_id = c.class_id AND cs.staff_id = s.staff_id;

-- 2. Find available classes for a specific date

SELECT cs.class_id, cs.start_time, cs.end_time, c.name, c.capacity, cs.schedule_id,
(
SELECT COUNT(*) 
FROM class_attendance ca
WHERE cs.schedule_id = ca.schedule_id
AND ca.attendance_status = 'Registered'
)
FROM class_schedule cs 
LEFT JOIN classes c ON c.class_id = cs.class_id
WHERE cs.start_time LIKE '2025-02-01%';

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member