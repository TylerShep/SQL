-- =============================================
-- Author:      Tyler Shepherd
-- Create date: 2023-10-10
-- Description: Creating a temp table that utilizes a cartesian join on IDs to system date, creating a Date for every ID possible
-- * Table names, column names, etc. has been aliased to protect DB Schema
-- =============================================

DECLARE @reportDate datetime, @communityId INT;
SET @fromDate = DATEADD(day, -730, GETDATE());

WITH DateRange AS (SELECT CAST(GETDATE() AS DATE) AS StatsDate
                   UNION ALL
                   SELECT DATEADD(day, -1, StatsDate)
                   FROM DateRange
                   WHERE StatsDate > @fromDate)

SELECT d.StatsDate,
       t1.ID as "TableID"
FROM DateRange d
    CROSS JOIN Table1 t1 WITH (NOLOCK)
ORDER BY 1 DESC, 2 ASC
OPTION (MAXRECURSION 0);
