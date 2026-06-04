-- ========================================================================================== 
--                Ensures that you are using the correct database 
-- ==========================================================================================  

USE DBVclDetails;    



-- ===========================================================================================================
--  Problem 41: Get all Makes that manufacture vehicles with one of the Top 3 Engine_CC values
-- ===========================================================================================================

SELECT DISTINCT M.MakeName
FROM VehicleDetails VD
INNER JOIN Makes M
    ON VD.MakeID = M.MakeID
WHERE Engine_CC IN (
    SELECT DISTINCT TOP (3) Engine_CC   -- get top 3 largest unique Engine_CC
    FROM VehicleDetails
    ORDER BY Engine_CC DESC
)
ORDER BY MakeName ASC;   -- alphabetical ordering of make names



-- ===========================================================================================================
--  Problem 42: Get a table of unique Engine_CC values and calculate tax per Engine_CC
-- ===========================================================================================================

SELECT
    Engine_CC,
    CASE 
        WHEN Engine_CC BETWEEN 0 AND 1000    THEN 100
        WHEN Engine_CC BETWEEN 1001 AND 2000 THEN 200
        WHEN Engine_CC BETWEEN 2001 AND 4000 THEN 300
        WHEN Engine_CC BETWEEN 4001 AND 6000 THEN 400
        WHEN Engine_CC BETWEEN 6001 AND 8000 THEN 500
        WHEN Engine_CC > 8000 THEN 600
        ELSE 0  -- default (shouldn’t happen if data is clean)
    END AS Tax
FROM (
    SELECT DISTINCT Engine_CC   -- deduplicate Engine_CC before applying tax calculation
    FROM VehicleDetails
) R1
ORDER BY Engine_CC DESC;   -- highest engine sizes first



-- ===========================================================================================================
--  Problem 43: Get each Make and the Total Number of Doors manufactured across all its vehicles
-- ===========================================================================================================

SELECT 
    M.MakeName,
    SUM(NumDoors) AS TotalDoorsNum   -- add up doors across all models/vehicles
FROM VehicleDetails VD
INNER JOIN Makes M
    ON VD.MakeID = M.MakeID
GROUP BY M.MakeName
ORDER BY TotalDoorsNum DESC;   -- makes with most doors at the top



-- ===========================================================================================================
--  Problem 44: Get the Total Number of Doors manufactured specifically by 'Ford'
-- ===========================================================================================================

SELECT 
    M.MakeName,
    SUM(NumDoors) AS TotalDoorsNum
FROM VehicleDetails VD
INNER JOIN Makes M
    ON VD.MakeID = M.MakeID
GROUP BY M.MakeName
HAVING M.MakeName = 'Ford';   -- filter after grouping to only show Ford



-- ===========================================================================================================
--  Problem 45: Get the Number of Models manufactured per Make
-- ===========================================================================================================

SELECT 
    M.MakeName,
    COUNT(*) AS ModelsNumber   -- counts how many models belong to each make
FROM MakeModels MkMd
INNER JOIN Makes M
    ON MkMd.MakeID = M.MakeID
GROUP BY M.MakeName
ORDER BY M.MakeName;   -- alphabetical ordering
