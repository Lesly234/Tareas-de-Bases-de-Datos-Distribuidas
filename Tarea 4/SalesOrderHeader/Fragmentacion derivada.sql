USE AdventureWorks2022;
GO

/* =========================================
   FRAGMENTO DERIVADO 1: NORTE
   ========================================= */
SELECT SOH.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID >= 1
  AND C.CustomerID <= 6024;


/* =========================================
   FRAGMENTO DERIVADO 2: SUR
   ========================================= */
SELECT SOH.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 6024
  AND C.CustomerID <= 12048;


/* =========================================
   FRAGMENTO DERIVADO 3: ESTE
   ========================================= */
SELECT SOH.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 12048
  AND C.CustomerID <= 18072;


/* =========================================
   FRAGMENTO DERIVADO 4: OESTE
   ========================================= */
SELECT SOH.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 18072
  AND C.CustomerID <= 24096;


/* =========================================
   FRAGMENTO DERIVADO 5: CENTRO
   ========================================= */
SELECT SOH.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 24096
  AND C.CustomerID <= 30118;