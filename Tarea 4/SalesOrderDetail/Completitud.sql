USE AdventureWorks;
GO

/* =========================================
   COMPLETITUD - SALES.SALESORDERDETAIL
   ========================================= */

SELECT COUNT(*) AS TotalOriginalSalesOrderDetail
FROM Sales.SalesOrderDetail;

SELECT 'SalesOrderDetail_Norte' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID >= 1 
  AND C.CustomerID <= 6024

UNION ALL

SELECT 'SalesOrderDetail_Sur' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 6024 
  AND C.CustomerID <= 12048

UNION ALL

SELECT 'SalesOrderDetail_Este' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 12048 
  AND C.CustomerID <= 18072

UNION ALL

SELECT 'SalesOrderDetail_Oeste' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 18072 
  AND C.CustomerID <= 24096

UNION ALL

SELECT 'SalesOrderDetail_Centro' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 24096 
  AND C.CustomerID <= 30118;


/* Detalles que no entraron en ningún fragmento.
   El resultado debe ser 0. */
SELECT COUNT(*) AS DetallesSinFragmento
FROM Sales.SalesOrderDetail AS SOD
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE SOD.SalesOrderID = SOH.SalesOrderID
      AND (
             (C.CustomerID >= 1 AND C.CustomerID <= 6024)
          OR (C.CustomerID > 6024 AND C.CustomerID <= 12048)
          OR (C.CustomerID > 12048 AND C.CustomerID <= 18072)
          OR (C.CustomerID > 18072 AND C.CustomerID <= 24096)
          OR (C.CustomerID > 24096 AND C.CustomerID <= 30118)
      )
);