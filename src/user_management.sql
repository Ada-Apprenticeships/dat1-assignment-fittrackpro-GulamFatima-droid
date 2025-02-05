-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members

SELECT member_id, first_name, last_name, email, join_date
FROM members;


-- 2. Update a member's contact information

UPDATE members
SET phone_number = '555-9876', email = 'emily.jones.updated@email.com'
WHERE member_id = 5;


--3. Count total number of members

SELECT COUNT(*) AS noOfMembers
FROM members;


-- 4. Find member with the most class registrations

WITH memberReg AS (
    SELECT m.member_id, m.first_name, m.last_name,   
    (  
        SELECT COUNT(*)  
        FROM class_attendance ca  
        WHERE ca.attendance_status = 'Registered' AND ca.member_id = m.member_id  
    )  AS registration_count
    FROM members m
)

SELECT * 
FROM memberReg
WHERE registration_count = 
(
    SELECT MAX(registration_count) FROM memberReg
);
 


-- 5. Find member with the least class registrations

WITH memberReg AS (
    SELECT m.member_id, m.first_name, m.last_name,   
    (  
        SELECT COUNT(*)  
        FROM class_attendance ca  
        WHERE ca.attendance_status = 'Registered' AND ca.member_id = m.member_id  
    )  
    AS registration_count
    FROM members m
)

SELECT * 
FROM memberReg
WHERE registration_count = 
(
    SELECT MIN(registration_count) FROM memberReg
);



-- 6. Calculate the percentage of members who have attended at least one class

WITH attendances AS (
    SELECT m.member_id, m.first_name, m.last_name,   
    (  
        SELECT COUNT(*)  
        FROM class_attendance ca  
        WHERE ca.attendance_status = 'Attended' 
        AND ca.member_id = m.member_id  
    )  
    AS attendance
    FROM members m
)

SELECT (COUNT(*) * 100 / (SELECT COUNT(*) FROM members)) AS percentage  
FROM attendances
WHERE attendance > 0;

