USE AdventureWorks;
GO

/* =========================================
   RECONSTRUCCIÓN - SALES.SALESORDERDETAIL
   ========================================= */

WITH FragmentosSalesOrderDetail AS (
    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID >= 1 AND C.CustomerID <= 6024

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 6024 AND C.CustomerID <= 12048

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 12048 AND C.CustomerID <= 18072

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 18072 AND C.CustomerID <= 24096

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 24096 AND C.CustomerID <= 30118
)
SELECT COUNT(*) AS DetallesFaltantes
FROM (
    SELECT SalesOrderID, SalesOrderDetailID
    FROM Sales.SalesOrderDetail

    EXCEPT

    SELECT SalesOrderID, SalesOrderDetailID
    FROM FragmentosSalesOrderDetail
) AS X;


/* Validación inversa: que no haya detalles extra en los fragmentos.
   El resultado debe ser 0. */
WITH FragmentosSalesOrderDetail AS (
    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID >= 1 AND C.CustomerID <= 6024

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 6024 AND C.CustomerID <= 12048

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 12048 AND C.CustomerID <= 18072

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 18072 AND C.CustomerID <= 24096

    UNION ALL

    SELECT SOD.SalesOrderID, SOD.SalesOrderDetailID
    FROM Sales.SalesOrderDetail AS SOD
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN Sales.Customer AS C
        ON SOH.CustomerID = C.CustomerID
    WHERE C.CustomerID > 24096 AND C.CustomerID <= 30118
)
SELECT COUNT(*) AS DetallesExtra
FROM (
    SELECT SalesOrderID, SalesOrderDetailID
    FROM FragmentosSalesOrderDetail

    EXCEPT

    SELECT SalesOrderID, SalesOrderDetailID
    FROM Sales.SalesOrderDetail
) AS X;