-- Initial SQLite setup
.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors

WITH inst i AS 
(
    SELECT staff_id, first_name
    FROM staff
)

SELECT 

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member