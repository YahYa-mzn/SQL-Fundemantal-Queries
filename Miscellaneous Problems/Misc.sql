-- ========================================================================================== 
--                Ensures that you are using the correct database 
-- ==========================================================================================  
USE DBMisc;



-- =====================================================================================================
-- Problem 1: Display all persons who are both employees and students
--            Show PersonID, full name, EmployeeID, salary, StudentID, and student number
-- =====================================================================================================

SELECT 
    P.PersonID,
    P.FirstName + ' ' + P.LastName AS FullName,
    E.EmployeeID,
    E.MonthlySalary,
    S.StudentID,
    S.StudentNumber

FROM Persons P
INNER JOIN Employees E     -- join persons with employees
    ON P.PersonID = E.PersonID
INNER JOIN Students S      -- also join with students → keeps only those who are both
    ON P.PersonID = S.PersonID

ORDER BY PersonID ASC;

--Alternative Using Left Join

SELECT 
	P.PersonID,
    P.FirstName + ' ' + P.LastName AS FullName,
    E.EmployeeID,
    E.MonthlySalary,
    S.StudentID,
    S.StudentNumber

FROM Persons P
LEFT OUTER JOIN Students S
	ON P.PersonID = S.PersonID
LEFT OUTER JOIN Employees E
	ON P.PersonID = E.PersonID

WHERE S.StudentID IS NOT NULL AND E.EmployeeID IS NOT NULL  --filtering, to show only the students and employees
ORDER BY PersonID ASC;



-- =========================================================================================
-- Problem 2: List all employees along with their manager's full name Include employees 
--            who don’t have managers (NULL case)
-- ========================================================================================= 

SELECT 
    R1.*,
    CASE 
        WHEN ManagerID IS NULL THEN NULL       -- no manager
        ELSE P.FirstName + ' ' + P.LastName    -- manager’s name
    END AS ManagerFullName
FROM
(
    SELECT 
        E.EmployeeID,
        E.PersonID,
        P.FirstName + ' ' + P.LastName AS FullName,
        E.ManagerID,
        -- find PersonID of the manager (to join back to Persons)
        (SELECT PersonID 
         FROM Employees 
         WHERE Employees.EmployeeID = E.ManagerID) AS ManagerPersonID
    FROM Employees E
    INNER JOIN Persons P
        ON E.PersonID = P.PersonID
) R1
LEFT OUTER JOIN Persons P
    ON R1.ManagerPersonID = P.PersonID;  -- bring back manager’s full name



-- ===================================================================================================
--                Problem 3: Show persons who are employees but NOT students
-- ===================================================================================================

SELECT 
    P.PersonID,
    E.EmployeeID,
    P.FirstName + ' ' + P.LastName AS FullName,
    E.MonthlySalary,
    E.ManagerID,
    P.Gender, 
    P.BirthDate

FROM Persons P
INNER JOIN Employees E
    ON P.PersonID = E.PersonID
LEFT OUTER JOIN Students S
    ON P.PersonID = S.PersonID

WHERE S.StudentID IS NULL   -- remove those who are also students
ORDER BY PersonID;


-- Alternative using NOT IN
SELECT 
    P.PersonID,
    E.EmployeeID,
    P.FirstName + ' ' + P.LastName AS FullName,
    E.MonthlySalary,
    E.ManagerID,
    P.Gender, 
    P.BirthDate

FROM Persons P
INNER JOIN Employees E
    ON P.PersonID = E.PersonID

WHERE P.PersonID NOT IN (   -- exclude IDs that appear in Students
    SELECT PersonID FROM Students
);



-- =========================================================================================
--         Problem 4: Find female employees who earn more than ANY male employee
-- ========================================================================================= 

SELECT 
    E1.EmployeeID,
    E1.PersonID,
    E1.MonthlySalary

FROM Employees E1
INNER JOIN Persons P1
    ON P1.PersonID = E1.PersonID

WHERE P1.Gender = 'F' 
  AND E1.MonthlySalary > (     -- compare to maximum male salary
        SELECT MAX(MonthlySalary) 
        FROM Employees E
        INNER JOIN Persons P
            ON P.PersonID = E.PersonID
        WHERE P.Gender = 'M'
  );



-- =======================================================================
--   Problem 5: Find all active students with their personal information
-- =======================================================================

SELECT 
    S.StudentID,
    P.*

FROM Persons P
INNER JOIN Students S
    ON P.PersonID = S.PersonID

WHERE S.IsActive = 1;   -- only active students



-- ====================================================================================
--         Problem 6: Show persons who are students but NOT employees
-- ====================================================================================

SELECT 
    S.StudentID,
    P.*

FROM Students S
INNER JOIN Persons P
    ON P.PersonID = S.PersonID
LEFT OUTER JOIN Employees E
    ON P.PersonID = E.PersonID

WHERE E.EmployeeID IS NULL     -- exclude those who are also employees
ORDER BY S.StudentID;


-- Alternative using SET Operator EXCEPT

SELECT 
    *   -- Only student personal info, excludes employment info
FROM Persons P

WHERE P.PersonID IN (
    SELECT PersonID FROM Students

    EXCEPT

    SELECT PersonID FROM Employees
);



-- ===============================================================================================
--     Problem 7: Find employees who have managers and display both employee and manager names
-- ===============================================================================================

SELECT 
    E.EmployeeID,
    P.FirstName + ' ' + P.LastName AS FullName,
    E.ManagerID,

    (SELECT FirstName + ' ' + LastName 
     FROM Persons P1
     INNER JOIN Employees E1
        ON P1.PersonID = E1.PersonID 
       AND E1.EmployeeID = E.ManagerID   -- match employee’s manager
    ) AS ManagerFullName

FROM Employees E
INNER JOIN Persons P
    ON P.PersonID = E.PersonID

WHERE E.ManagerID IS NOT NULL;  -- only employees with managers



-- =========================================================================================
--     Problem 9: Show all phone numbers used by employees and students (no duplicates)
-- =========================================================================================

SELECT Phone 
FROM Persons P
INNER JOIN Students S
    ON P.PersonID = S.PersonID

UNION    -- UNION removes duplicates

SELECT Phone
FROM Persons P
INNER JOIN Employees E
    ON P.PersonID = E.PersonID;



-- ========================================================================================
--       Problem 10: Find first names that appear in BOTH students and employees
-- ========================================================================================

SELECT FirstName
FROM Persons P
INNER JOIN Students S
    ON P.PersonID = S.PersonID

INTERSECT

SELECT FirstName
FROM Persons P
INNER JOIN Employees E
    ON P.PersonID = E.PersonID;



-- ====================================================================================
--      Problem 11: List email addresses belonging to employees but NOT students
-- ====================================================================================

SELECT Email 
FROM Persons P
INNER JOIN Employees E
    ON P.PersonID = E.PersonID

EXCEPT 

SELECT Email
FROM Persons P
INNER JOIN Students S
    ON P.PersonID = S.PersonID;

-- Alternative using NOT EXISTS (often faster)

SELECT Email
FROM Persons P
INNER JOIN Employees E 
    ON P.PersonID = E.PersonID

WHERE NOT EXISTS (
    SELECT TOP(1) PersonID
    FROM Students
    WHERE P.PersonID = Students.PersonID
);



-- =================================================================================
--      Problem 12: Show all persons who are neither employees nor students
-- =================================================================================

SELECT PersonID
FROM Persons

EXCEPT 

SELECT PersonID FROM Students

EXCEPT 

SELECT PersonID FROM Employees;   -- removes both employees & students



-- ==========================================================================================
--    Problem 13: Display employees earning more than the average salary of all employees
-- ==========================================================================================

SELECT 
    E.EmployeeID,
    E.MonthlySalary,
    P.PersonID,
    P.FirstName + ' ' + P.LastName AS FullName,
    P.Gender, 
    P.BirthDate

FROM Persons P
INNER JOIN Employees E
    ON P.PersonID = E.PersonID

WHERE E.MonthlySalary > (   -- compare to overall avg
    SELECT AVG(MonthlySalary) FROM Employees
);



-- ======================================================================================
--                 Problem 14: Count students by enrollment year
-- ======================================================================================

SELECT 
    YEAR(EnrollmentDate) AS EnrollmentYear,
    COUNT(*) AS NumberOfEnrollment

FROM Students 
GROUP BY YEAR(EnrollmentDate);



-- ========================================================================================
--  Problem 15: List persons born in the same month and year as at least one other person
-- ========================================================================================

SELECT 
    P.PersonID,
    P.FirstName + ' ' + P.LastName AS FullName,
    P.BirthDate,
    CONCAT(YEAR(P.BirthDate), '-', MONTH(P.BirthDate)) AS YearMonth

FROM Persons P

WHERE EXISTS (
    SELECT 1 
    FROM Persons P2 
    WHERE P2.PersonID != P.PersonID          -- exclude self
      AND YEAR(P2.BirthDate) = YEAR(P.BirthDate) 
      AND MONTH(P2.BirthDate) = MONTH(P.BirthDate)
)
ORDER BY YearMonth, P.PersonID;



-- ========================================================================================
--        Problem 16: Get all employees who are managed by 'Robert Williams'
-- ========================================================================================

SELECT 
    E1.EmployeeID,
    E1.PersonID,
    E1.ManagerID,
    Manager.PersonID
FROM Employees E1
INNER JOIN Employees Manager
    ON E1.ManagerID = Manager.EmployeeID
WHERE Manager.PersonID = (
    SELECT TOP (1) PersonID
    FROM Persons 
    WHERE FirstName = 'Robert' AND LastName = 'Williams'
);



-- =======================================================================================================
--  Problem 17: Get all employees along with Manager's name If no manager → employee is their own manager
-- =======================================================================================================

SELECT 
    E1.EmployeeID,
    E1.PersonID,
    P.FirstName + ' ' + P.LastName AS FullName,
    E1.ManagerID,
    CASE 
        WHEN ManagerID IS NULL THEN P.FirstName + ' ' + P.LastName
        ELSE (SELECT FirstName + ' ' + LastName
              FROM Persons 
              WHERE PersonID = (SELECT PersonID FROM Employees WHERE EmployeeID = E1.ManagerID)
             )
    END AS ManagerFullName

FROM Employees E1
INNER JOIN Persons P
    ON E1.PersonID = P.PersonID;



-- ================================================================================================
--  Problem 18: Create combined list of persons showing their role (Student, Employee, Both, None)
-- ================================================================================================

-- Version 1: EXISTS checks
SELECT 
    *,
    CASE 
        WHEN EXISTS (SELECT TOP(1) PersonID FROM Students WHERE P.PersonID = Students.PersonID) 
            THEN 'Student'

        ELSE 'NOT Student'
    END AS IsStudent,

    CASE 
        WHEN EXISTS (SELECT TOP(1) PersonID FROM Employees WHERE P.PersonID = Employees.PersonID)
            THEN 'Employee'

        ELSE 'NOT Employee'
    END AS IsEmployee

FROM Persons P;


-- Version 2: Cleaner with LEFT JOIN
SELECT  
    P.*,
    CASE 
        WHEN S.StudentID IS NOT NULL AND E.EmployeeID IS NOT NULL
            THEN 'Student & Employee'

        WHEN S.StudentID IS NOT NULL AND E.EmployeeID IS NULL
            THEN 'Student'

        WHEN S.StudentID IS NULL AND E.EmployeeID IS NOT NULL
            THEN 'Employee'

        ELSE 'Normal Person'
    END AS Status

FROM Persons P
LEFT JOIN Students S ON P.PersonID = S.PersonID
LEFT JOIN Employees E ON P.PersonID = E.PersonID;



-- ==========================================================================================
--             Problem 19: Find employees who earn more than their manager
-- ==========================================================================================

SELECT 
    E1.EmployeeID,
    E1.PersonID AS EmployeePersonID,
    Managers.EmployeeID AS ManagerID,
    Managers.PersonID AS ManagerPersonID,
    E1.MonthlySalary AS EmployeeSalary,
    Managers.MonthlySalary AS ManagerSalary,
    (E1.MonthlySalary - Managers.MonthlySalary) AS Difference

FROM Employees E1
INNER JOIN Employees Managers 
    ON E1.ManagerID = Managers.EmployeeID

WHERE E1.MonthlySalary > Managers.MonthlySalary;



-- ===========================================================================================================
--  Problem 20: Create appropriate indexes to optimize the most common query patterns in this database schema
-- ===========================================================================================================

--CREATE NONCLUSTERED INDEX IX_Employees_PersonID ON Employees(PersonID); 
--CREATE NONCLUSTERED INDEX IX_Students_PersonID ON Students(PersonID);

      -- The PersonID in each Students and Employees table already has a nonclustered index automatically,
	  -- because each time you define a unique constraint on a column, SQL Server creates an index on it!


CREATE NONCLUSTERED INDEX IX_Employees_ManagerID ON Employees(ManagerID);

      -- Here the ManagerID is a FK referencing the Employees table itself. It doesn't have an index 
      -- because it's not unique like PersonID.


