-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors

SELECT c.class_id, c.name AS class_name, s.first_name AS instructor_name
FROM classes c 
LEFT JOIN class_schedule cs, staff s
ON cs.class_id = c.class_id AND cs.staff_id = s.staff_id;

-- 2. Find available classes for a specific date

SELECT cs.class_id, c.name, cs.start_time, cs.end_time, 
(c.capacity - (
    SELECT COUNT(*) 
    FROM class_attendance ca
    WHERE cs.schedule_id = ca.schedule_id
    AND ca.attendance_status = 'Registered'
)) AS available_spots
FROM class_schedule cs 
LEFT JOIN classes c ON c.class_id = cs.class_id
WHERE cs.start_time LIKE '2025-02-01%';

-- 3. Register a member for a class

INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES (
(
    SELECT schedule_id 
    FROM class_schedule 
    WHERE class_id = 3 
    AND start_time LIKE '2025-02-01%'
),
11,'Registered');

-- 4. Cancel a class registration

DELETE FROM class_attendance
WHERE schedule_id =  7 
AND member_id = 2;

-- 5. List top 3 most popular classes

SELECT cs.class_id, c.name,
(
    SELECT COUNT(*) 
    FROM class_attendance ca
    WHERE cs.schedule_id = ca.schedule_id
    AND ca.attendance_status = 'Registered'
) AS registration_count
FROM class_schedule cs 
LEFT JOIN classes c ON c.class_id = cs.class_id
ORDER BY registration_count DESC
LIMIT 3;

-- 6. Calculate average number of classes per member

WITH attendances AS 
(
    SELECT m.member_id, (SELECT COUNT(*) FROM class_attendance ca WHERE m.member_id = ca.member_id) AS noOfClasses
    FROM members m
)

SELECT AVG(noOfClasses) AS average_no_classes
FROM attendances;