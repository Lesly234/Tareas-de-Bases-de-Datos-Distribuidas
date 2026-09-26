USE AdventureWorks2022;
GO

/* =========================================
   DISYUNCIÓN - SALES.SALESORDERHEADER
   ========================================= */

WITH FragmentosSalesOrderHeader AS (
    SELECT SOH.SalesOrderID, 'SalesOrderHeader_Norte' AS Fragmento
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID >= 1 AND C.CustomerID <= 6024

    UNION ALL

    SELECT SOH.SalesOrderID, 'SalesOrderHeader_Sur' AS Fragmento
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 6024 AND C.CustomerID <= 12048

    UNION ALL

    SELECT SOH.SalesOrderID, 'SalesOrderHeader_Este' AS Fragmento
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 12048 AND C.CustomerID <= 18072

    UNION ALL

    SELECT SOH.SalesOrderID, 'SalesOrderHeader_Oeste' AS Fragmento
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 18072 AND C.CustomerID <= 24096

    UNION ALL

    SELECT SOH.SalesOrderID, 'SalesOrderHeader_Centro' AS Fragmento
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 24096 AND C.CustomerID <= 30118
)
SELECT SalesOrderID, COUNT(*) AS Veces
FROM FragmentosSalesOrderHeader
GROUP BY SalesOrderID
HAVING COUNT(*) > 1;