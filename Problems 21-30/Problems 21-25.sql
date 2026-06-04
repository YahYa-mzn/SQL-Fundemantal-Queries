-- ==========================================================================================
--                Ensures that you are using the correct database
-- ==========================================================================================

USE DBVclDetails;



-- ==============================================================================================================
--				   Problem 21: Get Total Vehicles that number of doors is not specified
-- ==============================================================================================================

SELECT 
	COUNT(*) AS TotalNumber
FROM VehicleDetails
WHERE NumDoors IS NULL;
-- Counts vehicles where the NumDoors column is NULL (i.e., not specified).



-- ==============================================================================================================
--				     Problem 22: Get percentage of vehicles that has no doors specified
-- ==============================================================================================================

SELECT 
    CAST((SELECT COUNT(*) FROM VehicleDetails WHERE NumDoors IS NULL) AS FLOAT)
	/
    CAST((SELECT COUNT(*) FROM VehicleDetails) AS FLOAT) AS NoDoorsSpecifiedPerc;
-- Calculates the percentage of vehicles with no doors specified.
-- Outer CAST to FLOAT ensures decimal division instead of integer division.



-- ==============================================================================================================
--			Problem 23: Get MakeID , Make, SubModelName for all vehicles that have SubModelName 'Elite'
-- ==============================================================================================================

SELECT DISTINCT
	M.MakeID,
	M.MakeName, 
	SbMd.SubModelName
FROM VehicleDetails VD
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
INNER JOIN SubModels SbMd
	ON VD.SubModelID = SbMd.SubModelID
WHERE SubModelName = 'Elite'; 
-- DISTINCT ensures each Make/SubModel combination appears only once even if multiple vehicles exist.



-- ==============================================================================================================
--			Problem 24: Get all vehicles that have Engines > 3 Liters and have only 2 doors
-- ==============================================================================================================

SELECT *
FROM VehicleDetails
WHERE (Engine_Liter_Display > 3) AND (NumDoors = 2);
-- Filters vehicles with engine larger than 3 liters AND exactly 2 doors.



-- ==============================================================================================================
--			Problem 25: Get make and vehicles that the engine contains 'OHV' and have Cylinders = 4
-- ==============================================================================================================

SELECT 
	M.MakeName,
	VD.*
FROM VehicleDetails VD
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
WHERE (Engine LIKE '%OHV%') AND (Engine_Cylinders = 4);
-- Finds vehicles with engine descriptions containing 'OHV' and exactly 4 cylinders,
-- also returns the corresponding MakeName for each vehicle.
