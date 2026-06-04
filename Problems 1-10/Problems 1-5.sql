-- ==========================================================================================
--                Ensures that you are using the correct database
-- ==========================================================================================
USE DBVclDetails;




-- ==========================================================================================
--  Problem 1: Create Master View (joins lookup tables with VehicleDetails for readability)
-- ==========================================================================================

CREATE VIEW VehicleMasterDetails AS
(
    SELECT 
        VD.ID,                                       -- Vehicle unique identifier (PK from VehicleDetails)
        VD.MakeID, Mk.MakeName,                      -- Vehicle make (e.g., Toyota, Ford)
        VD.ModelID, MkM.ModelName,                   -- Vehicle model (e.g., Corolla, Mustang)
        VD.SubModelID, SbM.SubModelName,             -- Vehicle sub-model (e.g., Corolla LE, Mustang GT)
        VD.BodyID, B.BodyName,                       -- Body type (e.g., Sedan, SUV, Hatchback)
        VD.Vehicle_Display_Name,                     -- User-friendly vehicle display name
        VD.Year,                                     -- Manufacture year (e.g., 2021, 2022)
        VD.DriveTypeID, DT.DriveTypeName,            -- Drive type (e.g., FWD, RWD, AWD)
        VD.Engine, VD.Engine_CC,                     -- Engine specs (e.g., V6, 2000cc)
        VD.Engine_Cylinders, VD.Engine_Liter_Display,-- More engine details
        VD.FuelTypeID, FT.FuelTypeName,              -- Fuel type (Petrol, Diesel, Hybrid, Electric)
        VD.NumDoors                                  -- Number of doors (2, 4, 5)
												
    FROM VehicleDetails VD
    INNER JOIN Makes Mk       ON VD.MakeID = Mk.MakeID
    INNER JOIN MakeModels MkM ON VD.ModelID = MkM.ModelID AND VD.MakeID = MkM.MakeID         -- Ensures model belongs to make
    INNER JOIN SubModels SbM  ON VD.SubModelID = SbM.SubModelID AND VD.ModelID = SbM.ModelID -- Ensures submodel belongs to model
    INNER JOIN Bodies B       ON VD.BodyID = B.BodyID
    INNER JOIN DriveTypes DT  ON VD.DriveTypeID = DT.DriveTypeID
    INNER JOIN FuelTypes FT   ON VD.FuelTypeID = FT.FuelTypeID
);


-- Test query: View all records ordered by ID
SELECT * 
FROM VehicleMasterDetails
ORDER BY ID ASC;



-- ==========================================================================================
--                Problem 2: Get all vehicles made between 1950 and 2000
-- ==========================================================================================
SELECT * 
FROM VehicleDetails
WHERE Year BETWEEN 1950 AND 2000;



-- ==========================================================================================
--           Problem 3: Get total number of vehicles made between 1950 and 2000
-- ==========================================================================================
SELECT COUNT(*) AS VehicleNumber
FROM VehicleDetails
WHERE Year BETWEEN 1950 AND 2000;



-- ==========================================================================================
--   Problem 4: Get number of vehicles per make (1950–2000) ordered by vehicle count (DESC)
-- ==========================================================================================
SELECT M.MakeName, COUNT(*) AS VehicleNumber
FROM VehicleDetails VD
INNER JOIN Makes M ON VD.MakeID = M.MakeID
WHERE Year BETWEEN 1950 AND 2000
GROUP BY M.MakeName
ORDER BY VehicleNumber DESC;



-- ==========================================================================================
--       Problem 5: Get makes with more than 12,000 vehicles manufactured (1950–2000)
-- ==========================================================================================
SELECT M.MakeName, COUNT(*) AS VehicleNumber
FROM VehicleDetails VD
INNER JOIN Makes M ON VD.MakeID = M.MakeID
WHERE Year BETWEEN 1950 AND 2000
GROUP BY M.MakeName
HAVING COUNT(*) > 12000                 -- HAVING filters aggregated results
ORDER BY VehicleNumber DESC;

-- !!Tip!!: WHERE filters raw data, HAVING filters aggregated results!



-- ==========================================================================================
--       Alternative approach to Problem 5 using a subquery + WHERE instead of HAVING
-- ==========================================================================================
SELECT * 
FROM (
    SELECT M.MakeName, COUNT(*) AS VehicleNumber
    FROM VehicleDetails VD
    INNER JOIN Makes M ON VD.MakeID = M.MakeID
    WHERE Year BETWEEN 1950 AND 2000
    GROUP BY M.MakeName
) R1
WHERE R1.VehicleNumber > 12000
ORDER BY VehicleNumber DESC;