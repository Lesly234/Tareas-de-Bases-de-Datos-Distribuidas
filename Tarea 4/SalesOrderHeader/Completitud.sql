USE AdventureWorks2022;
GO

/* =========================================
   COMPLETITUD - SALES.SALESORDERHEADER
   ========================================= */

SELECT COUNT(*) AS TotalOriginalSalesOrderHeader
FROM Sales.SalesOrderHeader;

SELECT 'SalesOrderHeader_Norte' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID >= 1 
  AND C.CustomerID <= 6024

UNION ALL

SELECT 'SalesOrderHeader_Sur' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 6024 
  AND C.CustomerID <= 12048

UNION ALL

SELECT 'SalesOrderHeader_Este' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 12048 
  AND C.CustomerID <= 18072

UNION ALL

SELECT 'SalesOrderHeader_Oeste' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 18072 
  AND C.CustomerID <= 24096

UNION ALL

SELECT 'SalesOrderHeader_Centro' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 24096 
  AND C.CustomerID <= 30118;


/* Órdenes que no entraron en ningún fragmento derivado.
   El resultado debe ser 0. */
SELECT COUNT(*) AS OrdenesSinFragmento
FROM Sales.SalesOrderHeader AS SOH
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Customer AS C
    WHERE C.CustomerID = SOH.CustomerID
      AND (
             (C.CustomerID >= 1 AND C.CustomerID <= 6024)
          OR (C.CustomerID > 6024 AND C.CustomerID <= 12048)
          OR (C.CustomerID > 12048 AND C.CustomerID <= 18072)
          OR (C.CustomerID > 18072 AND C.CustomerID <= 24096)
          OR (C.CustomerID > 24096 AND C.CustomerID <= 30118)
      )
);