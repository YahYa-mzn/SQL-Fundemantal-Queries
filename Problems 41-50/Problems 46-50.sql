-- ========================================================================================== 
--                Ensures that you are using the correct database 
-- ==========================================================================================  
USE DBVclDetails;    



-- ===========================================================================================================
--			Problem 46: Get the highest 3 manufacturers that make the highest number of models
-- ===========================================================================================================

SELECT TOP (3)
	M.MakeName,
	COUNT(*) AS NumberOfModels
FROM Makes M
INNER JOIN MakeModels MkMd
	ON M.MakeID = MkMd.MakeID
GROUP BY M.MakeName
ORDER BY NumberOfModels DESC;
-- Finds the TOP 3 manufacturers with the most models by counting MakeModels per Make.
-- Uses ORDER BY DESC so the largest counts come first.



-- ===========================================================================================================
--						Problem 47: Get the highest number of models manufactured
-- ===========================================================================================================

SELECT 
	MAX(NumberOfModels) AS HighestNumberOfModels 
FROM (
	SELECT TOP (3)   -- TOP (3) is unnecessary here, you only need all groups to calculate MAX
		COUNT(*) AS NumberOfModels
	FROM Makes M
	INNER JOIN MakeModels MkMd
		ON M.MakeID = MkMd.MakeID
	GROUP BY M.MakeName
	ORDER BY NumberOfModels DESC
) R1;
-- Returns the maximum model count among all manufacturers.
-- Using TOP (3) inside the subquery isn’t needed, since MAX() will find the highest anyway.


-- Alternative solution (Better & Simpler)

SELECT TOP (1)
	COUNT(*) AS NumberOfModels
FROM MakeModels
GROUP BY MakeID
ORDER BY NumberOfModels DESC;
-- Finds the highest count directly by ordering groups and taking the first row.



-- ===========================================================================================================
--			Problem 48: Get the highest Manufacturers manufactured the highest number of models
-- ===========================================================================================================

SELECT 
	M.MakeName,
	COUNT(*) AS NumberOfModels
FROM MakeModels MkMd
INNER JOIN Makes M
	ON M.MakeID = MkMd.MakeID
GROUP BY M.MakeName
HAVING COUNT(*) = (
	SELECT TOP (1)
		COUNT(*) AS NumberOfModels
	FROM MakeModels
	GROUP BY MakeID
	ORDER BY NumberOfModels DESC
);
-- Finds manufacturers with the maximum number of models.
-- HAVING clause filters only those makes whose count = the global maximum.
-- Useful if multiple manufacturers tie for highest number.



-- Alternative Solution (Idea):
-- Reuse Problem 47’s query inside HAVING instead of rewriting it.



-- ===========================================================================================================
--			Problem 49: Get the Lowest Manufacturers manufactured the lowest number of models
-- ===========================================================================================================

SELECT 
	M.MakeName,
	COUNT(*) AS NumberOfModels
FROM Makes M
INNER JOIN MakeModels MkMd
	ON M.MakeID = MkMd.MakeID
GROUP BY M.MakeName
HAVING COUNT(*) = (
	SELECT TOP (1)
		COUNT(*) AS NumberOfModels
	FROM Makes M
	INNER JOIN MakeModels MkMd
		ON M.MakeID = MkMd.MakeID
	GROUP BY M.MakeID
	ORDER BY NumberOfModels ASC
);
-- Similar to Problem 48 but finds the minimum instead of maximum.
-- HAVING keeps only manufacturers whose count equals the global minimum.



-- Alternative Solution:
-- Use the same query as Problem 47 but replace MAX with MIN and adjust HAVING.



-- ===========================================================================================================
--		   Problem 50: Get all Fuel Types , each time the result should be showed in random order
-- ===========================================================================================================

SELECT * 
FROM FuelTypes
ORDER BY NEWID();
-- NEWID() generates a random uniqueidentifier for each row.
-- Ordering by NEWID() returns rows in a random order every time.
