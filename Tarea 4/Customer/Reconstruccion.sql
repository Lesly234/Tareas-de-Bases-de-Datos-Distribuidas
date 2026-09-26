USE AdventureWorks2022;
GO

/* =========================================
   RECONSTRUCCIÓN - SALES.CUSTOMER
   ========================================= */

WITH FragmentosCustomer AS (
    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID >= 1 AND CustomerID <= 6024

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 6024 AND CustomerID <= 12048

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 12048 AND CustomerID <= 18072

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 18072 AND CustomerID <= 24096

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 24096 AND CustomerID <= 30118
)
SELECT COUNT(*) AS ClientesFaltantes
FROM (
    SELECT CustomerID
    FROM Sales.Customer

    EXCEPT

    SELECT CustomerID
    FROM FragmentosCustomer
) AS X;


/* Validación inversa: que no haya clientes extra en los fragmentos.
   El resultado debe ser 0. */
WITH FragmentosCustomer AS (
    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID >= 1 AND CustomerID <= 6024

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 6024 AND CustomerID <= 12048

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 12048 AND CustomerID <= 18072

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 18072 AND CustomerID <= 24096

    UNION ALL

    SELECT CustomerID
    FROM Sales.Customer
    WHERE CustomerID > 24096 AND CustomerID <= 30118
)
SELECT COUNT(*) AS ClientesExtra
FROM (
    SELECT CustomerID
    FROM FragmentosCustomer

    EXCEPT

    SELECT CustomerID
    FROM Sales.Customer
) AS X;