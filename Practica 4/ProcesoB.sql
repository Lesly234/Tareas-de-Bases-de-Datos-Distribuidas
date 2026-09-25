USE AdventureWorks;
GO

-- TRANSACCIÓN B
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT
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

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

---escenario 2

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET LOCK_TIMEOUT 60000;

BEGIN TRANSACTION;

SELECT
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
COMMIT TRANSACTION;
SET LOCK_TIMEOUT -1;

--Ejercicio 2 
BEGIN TRANSACTION;

UPDATE Sales.SalesOrderDetail
SET OrderQty = 10
WHERE SalesOrderDetailID = (
    SELECT MIN(SalesOrderDetailID)
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = 43661
);

COMMIT TRANSACTION;

SELECT TOP (1)
    SalesOrderDetailID,
    OrderQty,
    UnitPrice,
    UnitPriceDiscount
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43661
ORDER BY SalesOrderDetailID;

USE AdventureWorks;
GO
----
BEGIN TRANSACTION;

UPDATE Sales.SalesOrderDetail
SET UnitPriceDiscount = 0.40
WHERE SalesOrderDetailID = (
    SELECT MIN(SalesOrderDetailID)
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = 43661
);

COMMIT TRANSACTION;

SELECT TOP (1)
    SalesOrderDetailID,
    OrderQty,
    UnitPrice,
    UnitPriceDiscount
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43661
ORDER BY SalesOrderDetailID;

/**EJERCICIO 3**/

USE AdventureWorks2022;
GO

-- VENTANA B
WAITFOR DELAY '00:00:05';
SET LOCK_TIMEOUT 10000;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @ProductID INT = 707;
    DECLARE @SalesOrderID INT;
    DECLARE @SpecialOfferID INT;
    DECLARE @UnitPrice MONEY;
    DECLARE @UnitPriceDiscount MONEY;

    SELECT TOP (1)
        @SalesOrderID = SalesOrderID,
        @SpecialOfferID = SpecialOfferID,
        @UnitPrice = UnitPrice,
        @UnitPriceDiscount = UnitPriceDiscount
    FROM Sales.SalesOrderDetail
    WHERE ProductID = @ProductID
    ORDER BY SalesOrderDetailID;

    INSERT INTO Sales.SalesOrderDetail
    (
        SalesOrderID,
        CarrierTrackingNumber,
        OrderQty,
        ProductID,
        SpecialOfferID,
        UnitPrice,
        UnitPriceDiscount,
        rowguid,
        ModifiedDate
    )
    VALUES
    (
        @SalesOrderID,
        'PHANTOM-LES',
        1,
        @ProductID,
        @SpecialOfferID,
        @UnitPrice,
        @UnitPriceDiscount,
        NEWID(),
        GETDATE()
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SELECT
        ERROR_NUMBER() AS NumeroError,
        ERROR_MESSAGE() AS MensajeError;
END CATCH;

SET LOCK_TIMEOUT -1;