USE AdventureWorks2022;
GO

SELECT SOD.*
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID >= 1 
  AND C.CustomerID <= 6024;


/* =========================
   FRAGMENTO DERIVADO 2: SALESORDERDETAIL_SUR
   ========================= */
SELECT SOD.*
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 6024 
  AND C.CustomerID <= 12048;


/* =========================
   FRAGMENTO DERIVADO 3: SALESORDERDETAIL_ESTE
   ========================= */
SELECT SOD.*
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 12048 
  AND C.CustomerID <= 18072;


/* =========================
   FRAGMENTO DERIVADO 4: SALESORDERDETAIL_OESTE
   ========================= */
SELECT SOD.*
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 18072 
  AND C.CustomerID <= 24096;


/* =========================
   FRAGMENTO DERIVADO 5: SALESORDERDETAIL_CENTRO
   ========================= */
SELECT SOD.*
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.Customer AS C
    ON SOH.CustomerID = C.CustomerID
WHERE C.CustomerID > 24096 
  AND C.CustomerID <= 30118;