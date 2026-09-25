USE AdventureWorks;
GO

BEGIN TRANSACTION;

UPDATE Production.ProductInventory
SET Quantity = 400
WHERE ProductID = 2
  AND LocationID = 50;

WAITFOR DELAY '00:00:20';
ROLLBACK TRANSACTION;




---CONSULTA 
  SELECT TOP (10)
    P.ProductID,
    P.Name AS NombreProducto,
    P.ListPrice AS Precio,
    I.LocationID,
    I.Quantity AS Existencias
FROM Production.Product AS P
INNER JOIN Production.ProductInventory AS I
    ON P.ProductID = I.ProductID
WHERE P.ProductID = 2
  AND I.LocationID = 50;
/*ORDER BY P.ProductID, I.LocationID;*/


  --EJERCICIO 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

DECLARE @Count INT;
DECLARE @Total DECIMAL(19, 4);
DECLARE @Average DECIMAL(19, 4);
DECLARE @CalculatedAverage DECIMAL(19, 4);

BEGIN TRANSACTION;


SELECT @Count = COUNT(*)
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43661;

SELECT
    'Cantidad inicial' AS Paso,
    @Count AS NumeroDetalles;

WAITFOR DELAY '00:00:20';

SELECT @Total =
    SUM(
        CAST(UnitPrice AS DECIMAL(19, 4))
        * OrderQty
        * (1 - CAST(UnitPriceDiscount AS DECIMAL(19, 4)))
    )
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43661;

SELECT
    'Total intermedio' AS Paso,
    @Total AS TotalPedido;

WAITFOR DELAY '00:00:20';


SELECT @Average =
    AVG(
        CAST(UnitPrice AS DECIMAL(19, 4))
        * OrderQty
        * (1 - CAST(UnitPriceDiscount AS DECIMAL(19, 4)))
    )
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43661;

SET @CalculatedAverage =
    @Total / NULLIF(@Count, 0);

SELECT
    @Count AS NumeroDetallesInicial,
    @Total AS TotalIntermedio,
    @Average AS PromedioActual,
    @CalculatedAverage AS PromedioCalculado,
    @Average - @CalculatedAverage AS Diferencia;

COMMIT TRANSACTION;

/**EJERCICIO 3*/
USE AdventureWorks2022;
GO

-- VENTANA A
BEGIN TRANSACTION;

DECLARE @ProductID INT = 707;

-- Primera lectura
SELECT
    COUNT(*) AS TotalFilasAntes
FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID;

SELECT TOP (10)
    SalesOrderID,
    SalesOrderDetailID,
    ProductID,
    OrderQty,
    UnitPrice,
    UnitPriceDiscount,
    CarrierTrackingNumber
FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID
ORDER BY SalesOrderDetailID DESC;
-- Retardo para que B intente insertar
WAITFOR DELAY '00:00:10';
print'Antes de la segunda lectura'

-- Segunda lectura
SELECT
    COUNT(*) AS TotalFilasDespues
FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID;

SELECT TOP (10)
    SalesOrderID,
    SalesOrderDetailID,
    ProductID,
    OrderQty,
    UnitPrice,
    UnitPriceDiscount,
    CarrierTrackingNumber
FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID
ORDER BY SalesOrderDetailID DESC;

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
