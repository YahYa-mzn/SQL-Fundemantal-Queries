-- ==========================================================================================
--                Ensures that you are using the correct database
-- ==========================================================================================

USE DBVclDetails;



-- ==============================================================================================================
--   Problem 6: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside
-- ==============================================================================================================

SELECT 
	M.MakeName,
	COUNT(*) AS VehicleNumber,
	-- Subquery here counts ALL vehicles in VehicleDetails (not just 1950–2000),
	-- which is why it can be selected as a single scalar value for every row.
	(SELECT COUNT(*) FROM VehicleDetails) AS TotalNumber 
FROM VehicleDetails VD
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
WHERE Year BETWEEN 1950 AND 2000
GROUP BY M.MakeName
ORDER BY VehicleNumber DESC;



-- ==============================================================================================================
-- Problem 7: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside it,
-- then calculate it's percentage
-- ==============================================================================================================

SELECT *, 
	-- Casting to float ensures decimal division (otherwise integer division may truncate).
	CAST(VehicleNumber AS float) / CAST(TotalNumber AS float) AS Perc
FROM 
(	
	SELECT 
		M.MakeName,
		COUNT(*) AS VehicleNumber,
		-- Again, total vehicle count across the whole table (not filtered by year).
		(SELECT COUNT(*) FROM VehicleDetails) AS TotalNumber
	FROM VehicleDetails VD
	INNER JOIN Makes M ON VD.MakeID = M.MakeID
	WHERE VD.Year BETWEEN 1950 AND 2000
	GROUP BY M.MakeName
) R1
ORDER BY VehicleNumber DESC;



-- ==============================================================================================================
--      Problem 8: Get MakeName, ModelName and Number of Vehicles per Model per Make between 1950 And 2000
-- ==============================================================================================================

SELECT 
	M.MakeName,
	Md.ModelName,
	COUNT(*) AS NumberOfVehicles
FROM VehicleDetails VD
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
INNER JOIN MakeModels Md
	ON VD.ModelID = Md.ModelID
WHERE Year BETWEEN 1950 AND 2000
GROUP BY M.MakeName, Md.ModelName
ORDER BY M.MakeName;
-- Grouping by both MakeName and ModelName ensures count per model within each make.



-- ==============================================================================================================
--								Problem 9:  Get all vehicles that runs with GAS
-- ==============================================================================================================

SELECT VD.*, FT.FuelTypeName
FROM VehicleDetails VD
INNER JOIN FuelTypes FT
	ON VD.FuelTypeID = FT.FuelTypeID
WHERE FT.FuelTypeName = N'GAS';          -- N bc of the nvarchar
-- Join with FuelTypes allows pulling readable FuelTypeName instead of just ID.



-- ==============================================================================================================
--							  Problem 10:  Get Total Makes that runs with GAS
-- ==============================================================================================================

SELECT DISTINCT
	M.MakeName,
	FT.FuelTypeName
FROM VehicleDetails VD
INNER JOIN Makes M
	ON VD.MakeID = M.MakeID
INNER JOIN FuelTypes FT
	ON VD.FuelTypeID = FT.FuelTypeID
WHERE FuelTypeName = N'GAS';

-- DISTINCT ensures each make appears only once, even if it has many GAS vehicles.
