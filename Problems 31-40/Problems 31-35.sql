-- ========================================================================================== 
--                Ensures that you are using the correct database 
-- ==========================================================================================  
USE DBVclDetails;    



-- =======================================================================================================================================
--  Problem 31: Get all Vehicle_Display_Name, year and add extra column to calculate the age of the car 
--              then sort the results by age desc (oldest cars first)
-- =======================================================================================================================================  
SELECT  
    Vehicle_Display_Name,  
    VD.Year,  
    (YEAR(GETDATE()) - VD.Year) AS Age   -- calculating age by subtracting car year from current year
FROM VehicleDetails VD 
ORDER BY Age DESC;  



-- =======================================================================================================================================
--  Problem 32: Get all Vehicle_Display_Name, year, Age for vehicles where age is between 15 and 25 years
-- =======================================================================================================================================  
SELECT  
    Vehicle_Display_Name,  
    VD.Year,  
    (YEAR(GETDATE()) - VD.Year) AS Age  
FROM VehicleDetails VD  
WHERE (YEAR(GETDATE()) - VD.Year) BETWEEN 15 AND 25   -- filter for cars aged 15–25 years
ORDER BY Age DESC;    

-- Alternative solution (same logic but using subquery to pre-calculate Age)
SELECT * 
FROM (  
    SELECT  
        Vehicle_Display_Name,  
        VD.Year,  
        YEAR(GETDATE()) - VD.Year AS Age  
    FROM VehicleDetails VD 
) R1  
WHERE Age BETWEEN 15 AND 25 
ORDER BY Age DESC;    



-- ================================================================================================================
--  Problem 33: Get Minimum Engine CC , Maximum Engine CC , and Average Engine CC of all Vehicles
-- ================================================================================================================  
SELECT  
    MIN(Engine_CC) AS MinEngine_CC,  
    MAX(Engine_CC) AS MaxEngine_CC,  
    AVG(Engine_CC) AS AvgEngine_CC   -- AVG automatically ignores NULL values
FROM VehicleDetails;   

-- Alternative approach (slower - uses correlated subqueries instead of aggregation)
SELECT  
    (SELECT TOP 1 Engine_CC  
     FROM VehicleDetails  
     WHERE Engine_CC IS NOT NULL  
     ORDER BY Engine_CC ASC  -- smallest Engine_CC
    ) AS MinEngine_CC,  
     
    (SELECT TOP 1 Engine_CC  
     FROM VehicleDetails  
     ORDER BY Engine_CC DESC  -- largest Engine_CC
    ) AS MaxEngine_CC,  
     
    (SELECT SUM(Engine_CC) / COUNT(Engine_CC) AS AvgEngine_CC  -- manual average calculation
     FROM VehicleDetails  
    ) AS AvgEngine_CC;    



-- ================================================================================================================
--  Problem 34: Get all vehicles that have the minimum Engine_CC
-- ================================================================================================================  
SELECT * 
FROM VehicleDetails 
WHERE Engine_CC = (  
    SELECT MIN(Engine_CC)  
    FROM VehicleDetails  
);  
-- returns all cars matching the smallest engine size  



-- ================================================================================================================
--  Problem 35: Get all vehicles that have the Maximum Engine_CC
-- ================================================================================================================  
SELECT * 
FROM VehicleDetails 
WHERE Engine_CC = (  
    SELECT MAX(Engine_CC)  
    FROM VehicleDetails  
);  
-- returns all cars matching the largest engine size
