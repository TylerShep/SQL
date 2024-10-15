-- =============================================
-- AUTHOR: Tyler Shepherd 
-- CREATED: 2024-02-21
-- DESCRIPTION: 
-- Utilizing MSSQL's dynamic sql function PIVOT to reformat the CCT table for better performance
-- Creates temp table where each CommunityID has its own row with BIT-type NameType columns
-- =============================================


WITH SrcPiv as
         (SELECT *
          FROM (SELECT cct.ID, ct.Name, cct.TypeID
                FROM TableTableType cct WITH (NOLOCK)
                         JOIN TableType ct WITH (NOLOCK) ON cct.ID = ct.ID) AS Src
                   PIVOT (
                   COUNT(Src.TypeID)
                   FOR Src.Name IN ([NameType1],[NameType2],[NameType3],[NameType4],[NameType5])) AS PivotSource)

SELECT ctp.ID,
       ctp.NameType1 AS "IsType1",
       ctp.NameType2 AS "IsType2",
       ctp.NameType3 AS "IsType3",
       ctp.NameType4 AS "IsType4",
       ctp.NameType5 AS "IsType5",
       SUM(CASE WHEN RCD.ID = 2 THEN 1 ELSE 0 END) AS "IsType6"

FROM Table1 AS ctp
         JOIN SrcPiv c WITH (NOLOCK) ON c.ID = ctp.ID
         LEFT JOIN Table3 RCD WITH (NOLOCK)
                   ON RCD.ID = c.ID

GROUP BY ctp.CommunityID, ctp.NameType1, ctp.NameType2, ctp.NameType3, ctp.NameType4,
         ctp.NameType5

ORDER BY 1;
