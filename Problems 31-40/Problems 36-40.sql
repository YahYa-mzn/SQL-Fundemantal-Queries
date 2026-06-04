-- ========================================================================================== 
--                Ensures that you are using the correct database 
-- ==========================================================================================  
USE DBVclDetails;    



-- ===========================================================================================================
--  Problem 36: Get all vehicles that have Engine_CC below average
-- ===========================================================================================================

SELECT 
    *
FROM VehicleDetails
WHERE Engine_CC < (
    SELECT AVG(Engine_CC)   -- calculates average Engine_CC across all vehicles
    FROM VehicleDetails
);



-- ===========================================================================================================
--  Problem 37: Get total number of vehicles that have Engine_CC above average
-- ===========================================================================================================

SELECT 
    COUNT(*) AS VehiclesNumAboveAvg   -- counts how many vehicles meet the condition
FROM (
    SELECT 
        * 
    FROM VehicleDetails
    WHERE Engine_CC > (
        SELECT AVG(Engine_CC)  -- same calculation as before, but filtering above average
        FROM VehicleDetails
    )
) R1;  -- subquery ensures we only count vehicles that qualify



-- ===========================================================================================================
--  Problem 38: Get all unique Engine_CC values and sort them in descending order
-- ===========================================================================================================

SELECT DISTINCT 
    Engine_CC
FROM VehicleDetails
ORDER BY Engine_CC DESC;  -- highest engine sizes at the top



-- ===========================================================================================================
--  Problem 39: Get the maximum 3 Engine_CC values
-- ===========================================================================================================

SELECT DISTINCT TOP 3     -- DISTINCT ensures no duplicate engine sizes
    Engine_CC
FROM VehicleDetails
ORDER BY Engine_CC DESC;  -- picks the 3 largest unique engine sizes



-- ===========================================================================================================
--  Problem 40: Get all Vehicles that have one of the top 3 Engine_CC values
-- ===========================================================================================================

SELECT *
FROM VehicleDetails
WHERE Engine_CC IN (      -- match only vehicles whose engine size is among the top 3
    SELECT DISTINCT TOP 3 
        Engine_CC
    FROM VehicleDetails
    ORDER BY Engine_CC DESC
);
