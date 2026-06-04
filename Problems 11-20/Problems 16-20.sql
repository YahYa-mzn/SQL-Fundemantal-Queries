-- ==========================================================================================
--                Ensures that you are using the correct database
-- ==========================================================================================

USE DBVclDetails;



-- ==============================================================================================================
--				     Problem 16: Get all Makes that manufactures DriveTypeName = FWD
-- ==============================================================================================================

SELECT DISTINCT
	M.MakeName,
	DT.DriveTypeName
FROM DriveTypes DT
INNER JOIN VehicleDetails VD
	ON VD.DriveTypeID = DT.DriveTypeID
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
WHERE DriveTypeName = 'FWD';
-- DISTINCT ensures each make appears only once even if it has multiple FWD vehicles.



-- ==============================================================================================================
--			   Problem 17: Get all total Makes that manufactures DriveTypeName = FWD
-- ==============================================================================================================

SELECT COUNT(*) AS TotalFWDMakes 
FROM (
	SELECT DISTINCT
		M.MakeName,
		DT.DriveTypeName
	FROM DriveTypes DT
	INNER JOIN VehicleDetails VD
		ON VD.DriveTypeID = DT.DriveTypeID
	INNER JOIN Makes M
		ON VD.MakeID = M.MakeID
	WHERE DriveTypeName = 'FWD'
) R1;
-- Subquery collects distinct makes with FWD vehicles, then outer query counts them.



-- Alternative solution (Better solution)

SELECT
	COUNT(DISTINCT M.MakeName) AS TotalFWDMakes
FROM DriveTypes DT
INNER JOIN VehicleDetails VD
	ON VD.DriveTypeID = DT.DriveTypeID
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
WHERE DriveTypeName = 'FWD';
-- Cleaner: directly counts unique makes without needing a subquery.



-- ==============================================================================================================
--   Problem 18: Get total vehicles per DriveTypeName per Make and order them per make asc then per total Desc
-- ==============================================================================================================

SELECT 
	DT.DriveTypeName,
	M.MakeName,
	COUNT(*) AS VehicleNumber
FROM VehicleDetails VD
INNER JOIN DriveTypes DT
	ON VD.DriveTypeID = DT.DriveTypeID
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
GROUP BY DT.DriveTypeName, M.MakeName
ORDER BY MakeName ASC, VehicleNumber DESC;
-- Groups by both drive type and make, so you see counts per make per drive type.
-- Results ordered alphabetically by Make, then by vehicle count descending.



-- ==============================================================================================================
--   Problem 19: Get total vehicles per DriveTypeName Per Make then filter only results with total > 10,000
-- ==============================================================================================================

SELECT 
	DT.DriveTypeName,
	M.MakeName,
	COUNT(*) AS VehicleNumber
FROM VehicleDetails VD
INNER JOIN DriveTypes DT
	ON VD.DriveTypeID = DT.DriveTypeID
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
GROUP BY DriveTypeName, MakeName
HAVING COUNT(*) > 10000
ORDER BY MakeName ASC, VehicleNumber DESC;
-- HAVING filters results after aggregation so only makes with more than 10,000 vehicles remain.



-- ==============================================================================================================
--				   Problem 20: Get all Vehicles that number of doors is not specified
-- ==============================================================================================================

SELECT *
FROM VehicleDetails
WHERE NumDoors IS NULL;
-- Finds vehicles where the NumDoors column has no value recorded.
