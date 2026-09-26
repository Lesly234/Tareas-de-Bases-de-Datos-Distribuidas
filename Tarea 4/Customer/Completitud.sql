USE AdventureWorks2022;
GO

/* =========================================
   COMPLETITUD - SALES.CUSTOMER
   ========================================= */

SELECT COUNT(*) AS TotalOriginalCustomer
FROM Sales.Customer;

SELECT 'Customer_Norte' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.Customer
WHERE CustomerID >= 1 AND CustomerID <= 6024

UNION ALL

SELECT 'Customer_Sur' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.Customer
WHERE CustomerID > 6024 AND CustomerID <= 12048

UNION ALL

SELECT 'Customer_Este' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.Customer
WHERE CustomerID > 12048 AND CustomerID <= 18072

UNION ALL

SELECT 'Customer_Oeste' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.Customer
WHERE CustomerID > 18072 AND CustomerID <= 24096

UNION ALL

SELECT 'Customer_Centro' AS Fragmento, COUNT(*) AS TotalRegistros
FROM Sales.Customer
WHERE CustomerID > 24096 AND CustomerID <= 30118;


/* Clientes que no entraron en ningún fragmento.
   El resultado debe ser 0. */
SELECT COUNT(*) AS ClientesSinFragmento
FROM Sales.Customer
WHERE NOT (
       (CustomerID >= 1 AND CustomerID <= 6024)
    OR (CustomerID > 6024 AND CustomerID <= 12048)
    OR (CustomerID > 12048 AND CustomerID <= 18072)
    OR (CustomerID > 18072 AND CustomerID <= 24096)
    OR (CustomerID > 24096 AND CustomerID <= 30118)
);