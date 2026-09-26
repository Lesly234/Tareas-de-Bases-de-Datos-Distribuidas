USE AdventureWorks2022;
GO

/* =========================================
   DISYUNCIÓN - SALES.CUSTOMER
   ========================================= */

WITH FragmentosCustomer AS (
    SELECT CustomerID, 'Customer_Norte' AS Fragmento
    FROM Sales.Customer
    WHERE CustomerID >= 1 AND CustomerID <= 6024

    UNION ALL

    SELECT CustomerID, 'Customer_Sur' AS Fragmento
    FROM Sales.Customer
    WHERE CustomerID > 6024 AND CustomerID <= 12048

    UNION ALL

    SELECT CustomerID, 'Customer_Este' AS Fragmento
    FROM Sales.Customer
    WHERE CustomerID > 12048 AND CustomerID <= 18072

    UNION ALL

    SELECT CustomerID, 'Customer_Oeste' AS Fragmento
    FROM Sales.Customer
    WHERE CustomerID > 18072 AND CustomerID <= 24096

    UNION ALL

    SELECT CustomerID, 'Customer_Centro' AS Fragmento
    FROM Sales.Customer
    WHERE CustomerID > 24096 AND CustomerID <= 30118
)
SELECT CustomerID, COUNT(*) AS Veces
FROM FragmentosCustomer
GROUP BY CustomerID
HAVING COUNT(*) > 1;