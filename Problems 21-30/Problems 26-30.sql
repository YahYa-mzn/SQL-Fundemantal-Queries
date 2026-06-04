-- ==========================================================================================
--                Ensures that you are using the correct database
-- ==========================================================================================

USE DBVclDetails;



-- ==============================================================================================================
--			    Problem 26: Get all vehicles that their body is 'Sport Utility' and Year > 2020
-- ==============================================================================================================

SELECT 
	B.BodyName,
	VD.*

FROM VehicleDetails VD
INNER JOIN Bodies B
	ON VD.BodyID = B.BodyID

WHERE B.BodyName = 'Sport Utility' AND Year > 2020;
-- Filters vehicles with body type 'Sport Utility' and manufactured after 2020.



-- ==============================================================================================================
--			   Problem 27: Get all vehicles that their Body is 'Coupe' or 'Hatchback' or 'Sedan'
-- ==============================================================================================================

SELECT 
	B.BodyName,
	VD.*

FROM VehicleDetails VD
INNER JOIN Bodies B
	ON VD.BodyID = B.BodyID

WHERE B.BodyName IN ('Coupe', 'HatchBack', 'Sedan')
ORDER BY B.BodyName;
-- Uses IN() for cleaner syntax instead of multiple OR conditions.
-- Results are ordered by BodyName alphabetically.



-- =================================================================================================================================
--  Problem 28: Get all vehicles that their body is 'Coupe' or 'Hatchback' or 'Sedan' and manufactured in year 2008, 2020, or 2021
-- =================================================================================================================================

SELECT 
	B.BodyName,
	VD.*

FROM VehicleDetails VD
INNER JOIN Bodies B
	ON VD.BodyID = B.BodyID

WHERE B.BodyName IN ('Coupe', 'HatchBack', 'Sedan') AND Year IN (2008, 2020, 2021)
ORDER BY B.BodyName;
-- Combines filters on body type and specific manufacturing years.



-- ==============================================================================================================
--				  Problem 29: Return found=1 if there is any vehicle made in year 1950
-- ==============================================================================================================

SELECT  
	Found = 1

WHERE EXISTS(					
	SELECT 1
	FROM VehicleDetails
	WHERE Year = 1950
);
-- EXISTS is best practice: SQL Server stops searching as soon as one row matches.



-- Alternative solution (Using 'CASE')
SELECT 
	CASE 
		WHEN (SELECT TOP 1 1 FROM VehicleDetails WHERE Year = 1950) = 1
			THEN 1

		ELSE 0
	END Found;
-- Works but less efficient; scalar subquery is executed and compared for equality.



-- =====================================================================================================================================================
--  Problem 30: Get all Vehicle_Display_Name, NumDoors and add extra column to describe number of doors by words, 
--  and if door is null display 'Not Set'
-- =====================================================================================================================================================

SELECT 
	Vehicle_Display_Name,
	NumDoors,

	CASE 
		WHEN NumDoors = 0 THEN 'Zero Doors'
		WHEN NumDoors = 1 THEN 'One Door'
		WHEN NumDoors = 2 THEN 'Two Doors'
		WHEN NumDoors = 3 THEN 'Three Doors'
		WHEN NumDoors = 4 THEN 'Four Doors'
		WHEN NumDoors = 5 THEN 'Five Doors'
		WHEN NumDoors = 6 THEN 'Six Doors'
		WHEN NumDoors = 7 THEN 'Seven Doors'
		WHEN NumDoors = 8 THEN 'Eight Doors'
		WHEN NumDoors IS NULL THEN 'Not Set'

		ELSE 'Unknown'
	END DoorsDescription

FROM VehicleDetails
ORDER BY NumDoors ASC;
-- Converts numeric NumDoors into human-readable words.
-- Handles NULL values by showing 'Not Set'.
-- ORDER BY NumDoors puts vehicles in ascending order by number of doors.
