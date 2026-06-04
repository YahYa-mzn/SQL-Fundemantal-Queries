-- ==========================================================================================
--                Ensures that you are using the correct database
-- ==========================================================================================

USE DBVclDetails;



-- ==============================================================================================================
--							   Problem 11: Get Total Makes that runs with GAS
-- ==============================================================================================================

SELECT COUNT(*) AS TotalMakesRunsOnGAS 
FROM(
	SELECT DISTINCT
		M.MakeName,
		FT.FuelTypeName
	FROM VehicleDetails VD 
	INNER JOIN Makes M
		ON VD.MakeID = M.MakeID
	INNER JOIN FuelTypes FT 
		ON VD.FuelTypeID = FT.FuelTypeID
	WHERE FT.FuelTypeName = N'GAS'
) R1
-- Subquery (R1) ensures each MakeName appears only once (DISTINCT),
-- then outer COUNT(*) gives total unique makes that run on GAS.



-- ==============================================================================================================
--			  Problem 12: Count Vehicles by make and order them by NumberOfVehicles from high to low
-- ==============================================================================================================

SELECT
	M.MakeName,
	COUNT(*) AS NumberOfVehicles
FROM VehicleDetails VD
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
GROUP BY MakeName
ORDER BY NumberOfVehicles DESC;
-- Grouping by Make gives total vehicle count per make, sorted descending.



-- ==============================================================================================================
--			 Problem 13: Get all Makes/Count Of Vehicles that manufactures Between 10000 And 20000
-- ==============================================================================================================

SELECT
	M.MakeName,
	COUNT(*) AS NumberOfVehicles
FROM VehicleDetails VD
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
GROUP BY MakeName
HAVING COUNT(*) BETWEEN 10000 AND 20000
ORDER BY NumberOfVehicles DESC;
-- HAVING is used here because the condition applies on aggregated values (COUNT).



-- Alternative solution (using WHERE Clause)

SELECT * 
FROM (
	SELECT
		M.MakeName,
		COUNT(*) AS NumberOfVehicles
	FROM VehicleDetails VD
	INNER JOIN Makes M
		ON VD.MakeID = M.MakeID
	GROUP BY MakeName
) R1
WHERE R1.NumberOfVehicles BETWEEN 10000 AND 20000;
-- Same logic as HAVING, but wraps aggregation in a subquery,
-- then filters with WHERE instead of HAVING.



-- ==============================================================================================================
--						   Problem 14: Get all Makes with make starts with 'B'
-- ==============================================================================================================

SELECT * 
FROM Makes
WHERE MakeName LIKE 'B%';
-- LIKE 'B%' matches any make name that begins with 'B'.



-- ==============================================================================================================
--						   Problem 15: Get all Makes with make ends with 'W'
-- ==============================================================================================================

SELECT *
FROM Makes
WHERE MakeName LIKE '%W';
-- LIKE '%W' matches any make name that ends with 'W'.
