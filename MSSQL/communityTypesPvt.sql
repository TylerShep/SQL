--Utilizing MSSQL's dynamic sql function PIVOT to reformat the CCT table for better performance
--Creates temp table where each CommunityID has its own row with BIT-type NameType columns

WITH CommmunityTypePiv as
         (SELECT *
          FROM (SELECT cct.CommunityID, ct.Name, cct.CommunityTypeID
                FROM CommunityCommunityType cct WITH (NOLOCK)
                         JOIN CommunityType ct WITH (NOLOCK) ON cct.CommunityTypeID = ct.ID) as Src
                   PIVOT (
                   COUNT(Src.CommunityTypeID)
                   FOR Src.Name IN ([NameType1],[NameType2],[NameType3],[NameType4],[NameType5])) as PivotSource)

SELECT ctp.CommunityID,
       ctp.NameType1 AS "IsType1",
       ctp.NameType2 AS "IsType2",
       ctp.NameType3 AS "IsType3",
       ctp.NameType4 AS "IsType4",
       ctp.NameType5 AS "IsType5",
       SUM(CASE WHEN RCD.ResManInterfaceID = 2 THEN 1 ELSE 0 END) AS "IsType6"

FROM CommmunityTypePiv as ctp
         JOIN Community c WITH (NOLOCK) on c.ID = ctp.CommunityID
         LEFT JOIN ResManConnectionData RCD WITH (NOLOCK)
                   ON RCD.PMSystemConnectionDataID = c.PropertyManagementRetrieverDataID

GROUP BY ctp.CommunityID, ctp.NameType1, ctp.NameType2, ctp.NameType3, ctp.NameType4,
         ctp.NameType5

ORDER BY 1;
