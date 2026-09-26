USE AdventureWorks2022;
GO

/* =========================================
   RECONSTRUCCIÓN - SALES.SALESORDERHEADER
   ========================================= */

WITH FragmentosSalesOrderHeader AS (
    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID >= 1 AND C.CustomerID <= 6024

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 6024 AND C.CustomerID <= 12048

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 12048 AND C.CustomerID <= 18072

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 18072 AND C.CustomerID <= 24096

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 24096 AND C.CustomerID <= 30118
)
SELECT COUNT(*) AS OrdenesFaltantes
FROM (
    SELECT SalesOrderID
    FROM Sales.SalesOrderHeader

    EXCEPT

    SELECT SalesOrderID
    FROM FragmentosSalesOrderHeader
) AS X;


/* Validación inversa: que no haya órdenes extra en los fragmentos.
   El resultado debe ser 0. */
WITH FragmentosSalesOrderHeader AS (
    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID >= 1 AND C.CustomerID <= 6024

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 6024 AND C.CustomerID <= 12048

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 12048 AND C.CustomerID <= 18072

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 18072 AND C.CustomerID <= 24096

    UNION ALL

    SELECT SOH.SalesOrderID
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 24096 AND C.CustomerID <= 30118
)
SELECT COUNT(*) AS OrdenesExtra
FROM (
    SELECT SalesOrderID
    FROM FragmentosSalesOrderHeader

    EXCEPT

    SELECT SalesOrderID
    FROM Sales.SalesOrderHeader
) AS X;