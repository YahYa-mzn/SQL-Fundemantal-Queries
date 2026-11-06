USE DBMisc;

-- Problem 1: HR needs a quarterly overview showing company-wide salary statistics: 
		 -- Total monthly expenditure, average salary, minimum pay, and top salary
SELECT
	SUM(MonthlySalary) AS TotalMonthlyExpenditure,
	AVG(MonthlySalary) AS AverageSalary,
	MIN(MonthlySalary) AS MinimumPay,
	MAX(MonthlySalary) AS MaximumPay
FROM Employees;



-- Problem 2: Admissions office needs a report showing total student counts separated by gender, 
		   -- along with the average age of enrolled students in each group.
SELECT
	P.Gender,
	COUNT(*) AS TotalStudents,
	AVG(DATEDIFF(YEAR, P.BirthDate, GETDATE())) AS AvgBirthDate
FROM Persons AS P
INNER JOIN Students AS S
	ON S.PersonID = P.PersonID
GROUP BY (P.Gender);



-- Problem 3: Finance needs a departmental budget review. 
		   -- Display each manager's ID, 
		   -- how many staff report directly to them, 
		   -- and the total monthly salary budget consumed by their direct team.
SELECT 
	E.ManagerID,
	COUNT(*) AS TeamMembers,
	SUM(MonthlySalary) AS TeamMonthlySalary

FROM Employees AS E
WHERE ManagerID IS NOT NULL
GROUP BY (E.ManagerID);
GO

-- Problem 4: The admissions team is auditing active versus inactive students. 
           -- Produce a report grouping students by status, 
           -- showing total count in each status alongside the earliest and most recent enrollment dates.
SELECT 
    IsActive,
    COUNT(StudentID) AS TotalStudents,
    MIN(EnrollmentDate) AS EarliestEnrollment,
    MAX(EnrollmentDate) AS LatestEnrollment
FROM Students
GROUP BY IsActive
ORDER BY IsActive DESC;



-- Problem 5: Planning needs to see growth trends over time. 
		   -- Produce a list showing the total number of new students enrolled during each calendar year.
SELECT 
	YEAR(EnrollmentDate) AS CalenderYear,
	COUNT(*) AS TotalStudents

FROM Students
GROUP BY (YEAR(EnrollmentDate));



-- Problem 6: Produce a report listing all employees ordered from highest to lowest salary within their gender group. 
		   -- Assign sequential pay tiers starting at 1, ensuring that employees with identical salaries 
		   -- share the exact same tier number without creating gaps in the numbering sequence.
SELECT
	DENSE_RANK() OVER(PARTITION BY P.Gender ORDER BY E.MonthlySalary DESC) AS Rank,
	P.Gender,
	E.EmployeeID,
	E.MonthlySalary

FROM Employees AS E
INNER JOIN Persons AS P
	ON P.PersonID = E.PersonID



-- Problem 7: Audit needs an export file where every single employee row receives a unique integer sequence number from 1 to N, 
		   -- ordered strictly from highest monthly salary down to lowest.
SELECT
	ROW_NUMBER() OVER(ORDER BY MonthlySalary DESC) AS Sequence,
	*
FROM Employees;



-- Problem 8: Marketing wants to highlight newly joined students on social media. 
		   -- Select exactly one male and one female student—specifically whoever enrolled most recently in each group.
-- I used DENSE_RANK(), not RANK() or ROW_NUMBER();
-- because they won't be efficient if there are multiple students joined at the same date
WITH CTE_GetLeastEnrollmentsPerGender AS
(
	SELECT
		P.PersonID,
		S.StudentID,
		P.FirstName + ' ' + P.LastName AS FullName,
		P.Gender,
		S.EnrollmentDate,
		DENSE_RANK() OVER(PARTITION BY P.Gender ORDER BY EnrollmentDate DESC) AS LeastEnrollmentsRank_PerGender

	FROM Persons AS P
	INNER JOIN Students AS S
		ON S.PersonID = P.PersonID
)
SELECT * 
FROM CTE_GetLeastEnrollmentsPerGender
WHERE LeastEnrollmentsRank_PerGender = 1;



-- Problem 9: HR wants an official company leaderboard showing full names, salaries, and salary ranks. 
		   -- Equal salaries must receive equal rank positions without creating gaps in the sequence.
SELECT
    DENSE_RANK() OVER(ORDER BY E.MonthlySalary DESC) AS Rank,
    P.FirstName + ' ' + P.LastName AS FullName,
    E.MonthlySalary

FROM Employees E
INNER JOIN Persons P
	ON P.PersonID = E.PersonID;


-- Problem 10: Full Salary Timeline Matrix
SELECT 
    EmployeeID,
    ChangeDate,
    LAG(NewSalary) OVER (PARTITION BY EmployeeID ORDER BY ChangeDate) AS PreviousSalary,
    NewSalary AS CurrentSalary,
    LEAD(NewSalary) OVER (PARTITION BY EmployeeID ORDER BY ChangeDate) AS NextSalary

FROM SalaryHistory
ORDER BY EmployeeID ASC, ChangeDate ASC;



-- Problem 11: Salary Adjustment Delta Tracker
		-- (I think it's great for a dashboard)
WITH CTE_GetUpdatedDifference AS (
    SELECT
        EmployeeID,
        ChangeDate,
        NewSalary,
        NewSalary - LAG(NewSalary) OVER(PARTITION BY EmployeeID ORDER BY ChangeDate ASC) AS SalaryDifference
    FROM SalaryHistory
)
SELECT 
    ROW_NUMBER() OVER(PARTITION BY EmployeeID ORDER BY ChangeDate ASC) AS IncrementNumber,
    EmployeeID,
    ChangeDate,
    NewSalary,
    SalaryDifference
FROM CTE_GetUpdatedDifference
WHERE SalaryDifference IS NOT NULL;



-- Problem 12: Pay Rate Active Duration & Next Change Date
SELECT 
	EmployeeID,
	ChangeDate,
	ISNULL((LEAD(ChangeDate) OVER(PARTITION BY EmployeeID ORDER BY ChangeDate)), GETDATE()) AS NextChangeDate
FROM SalaryHistory;



-- Problem 13: Dual-Role Compensation & Gender Rank Report
SELECT
	DENSE_RANK() OVER(PARTITION BY P.Gender ORDER BY E.MonthlySalary DESC) AS SalaryRank,
	P.FirstName + ' ' + P.LastName AS FullName,
	P.Gender,
	S.StudentNumber,
	E.MonthlySalary

FROM Persons AS P

INNER JOIN Students AS S
	ON S.PersonID = P.PersonID

INNER JOIN Employees AS E
	ON E.PersonID = P.PersonID;



-- Problem 14: Multi-CTE Query vs. Standard Join
            -- Retrieve all active students who are also employed, displaying their 
            -- PersonID, StudentNumber, and MonthlySalary.

-- Approach 1: using CTEs
WITH CTE_ActiveStudents AS (
    SELECT 
        PersonID,
        StudentNumber
    FROM Students
    WHERE IsActive = 1
),
CTE_CompanyEmployees AS (
    SELECT 
        PersonID,
        MonthlySalary
    FROM Employees
)
SELECT
    CTE_AS.PersonID,
    CTE_AS.StudentNumber,
    CTE_CE.MonthlySalary
FROM CTE_ActiveStudents AS CTE_AS
INNER JOIN CTE_CompanyEmployees AS CTE_CE
    ON CTE_CE.PersonID = CTE_AS.PersonID;

-- Approach 2:Inner Join
SELECT 
    s.PersonID, 
    s.StudentNumber, 
    e.MonthlySalary 
FROM Students AS s
INNER JOIN Employees AS e 
    ON s.PersonID = e.PersonID
WHERE s.IsActive = 1;



-- Problem 15: CTE for Aggregated Metrics & Ranking
			-- Calculate total monthly payroll per manager for teams costing over $10,000, 
			-- and rank managers by team expenditure.

-- Approach 1: CTE (Prevents repetitive aggregate expressions)
WITH CTE_TeamCosts AS (
    SELECT 
        ManagerID, 
        SUM(MonthlySalary) AS TeamCost
    FROM Employees
    WHERE ManagerID IS NOT NULL
    GROUP BY ManagerID
)
SELECT
    DENSE_RANK() OVER(ORDER BY TeamCost DESC) AS CostRank,
    ManagerID,
    TeamCost
FROM CTE_TeamCosts 
WHERE TeamCost > 10000;

-- Approach 2: using HAVING and multiple aggregate expressions
SELECT 
    DENSE_RANK() OVER(ORDER BY SUM(MonthlySalary) DESC) AS CostRank,
    ManagerID, 
    SUM(MonthlySalary) AS TeamCost
FROM Employees
WHERE ManagerID IS NOT NULL
GROUP BY ManagerID
HAVING SUM(MonthlySalary) > 10000;



-- Problem 16: Employee Heirarchy 

WITH OrgHierarchy AS (
    -- Anchor Member: Find the top Managers (executed only once to provide the structure)
    SELECT 
        EmployeeID,
        ManagerID,
        MonthlySalary,
        CAST(EmployeeID AS NVARCHAR(MAX)) AS Hierarchy,
        1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive Member: Per each level find the sub levels below it (recursively called per each level)
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.MonthlySalary,
        h.Hierarchy + ' -> ' + CAST(e.EmployeeID AS NVARCHAR(MAX)) AS Hierarchy,
        h.Level + 1 AS Level
    FROM Employees e
    INNER JOIN OrgHierarchy h 
		ON e.ManagerID = h.EmployeeID
)

-- You can even add analytical functions and do whatever with the result set...
SELECT 
    EmployeeID,
    MonthlySalary,
    Hierarchy,
    Level
FROM OrgHierarchy
ORDER BY Hierarchy;