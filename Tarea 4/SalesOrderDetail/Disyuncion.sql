USE AdventureWorks2022;
GO

/* =========================================
   DISYUNCIÓN - SALES.SALESORDERDETAIL
   ========================================= */

WITH FragmentosSalesOrderDetail AS (
    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID, 'SalesOrderDetail_Norte' AS Fragmento
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID >= 1 AND C.CustomerID <= 6024

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID, 'SalesOrderDetail_Sur' AS Fragmento
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 6024 AND C.CustomerID <= 12048

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID, 'SalesOrderDetail_Este' AS Fragmento
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 12048 AND C.CustomerID <= 18072

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID, 'SalesOrderDetail_Oeste' AS Fragmento
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 18072 AND C.CustomerID <= 24096

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID, 'SalesOrderDetail_Centro' AS Fragmento
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 24096 AND C.CustomerID <= 30118
)
SELECT SalesOrderID, SalesOrderDetailID, COUNT(*) AS Veces
FROM FragmentosSalesOrderDetail
GROUP BY SalesOrderID, SalesOrderDetailID
HAVING COUNT(*) > 1;