SET STATISTICS IO ON;
SET STATISTICS TIME ON;
--CONSULTA 2
--CONSULTA ORIGINAL
SELECT e.NationalIDNumber, p.FirstName, p.LastName, edh.DepartmentID,
       (SELECT AVG(rh.Rate) FROM HumanResources.EmployeePayHistory rh 
        WHERE rh.BusinessEntityID = e.BusinessEntityID) as PromedioSalario
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL;

--CONSULTA OPTIMIZADA
SELECT e.NationalIDNumber, p.FirstName, p.LastName, edh.DepartmentID,
AVG(rh.Rate) as PromedioSalario
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
LEFT JOIN HumanResources.EmployeePayHistory rh
    ON rh.BusinessEntityID = e.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY e.NationalIDNumber, p.FirstName, p.LastName, edh.DepartmentID;

--Creación de índice no agrupado 
CREATE NONCLUSTERED INDEX IX_Person_FirstName
ON Person.Person (FirstName)
INCLUDE (LastName)

--CONSULTA 3
SELECT sod.SalesOrderID, p.ProductID, p.Name
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.CategoryID = 1 OR p.CategoryID = 2 OR p.CategoryID = 3 OR p.ListPrice > 500;	
 

 WITH categoria as (
 SELECT ps.ProductSubcategoryID
 FROM Production.ProductCategory pc
 JOIN Production.ProductSubcategory ps on ps.ProductCategoryID=Pc.ProductCategoryID
 where pc.ProductCategoryID between 1 and 3
 )
SELECT sod.SalesOrderID, p.ProductID, p.Name
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN categoria c on p.ProductSubcategoryID=c.ProductSubcategoryID
where p.ListPrice>500;

--Indices 
CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_ProductID
ON Sales.SalesOrderDetail(ProductID)
INCLUDE (SalesOrderID)

CREATE NONCLUSTERED INDEX IX_ProductSubcategory_ProductCategoryID
ON Production.ProductSubcategory (ProductCategoryID)

--CONSULTA 4
SELECT YEAR(soh.OrderDate) AS Año, MONTH(soh.OrderDate) AS Mes,
       COUNT(*) AS TotalPedidos, SUM(sod.LineTotal) AS TotalVentas
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate);

CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_OrderDate
ON Sales.SalesOrderHeader (OrderDate)
INCLUDE (SalesOrderID)

--Consulta 6
SELECT c.CustomerID, p.FirstName AS Name, COUNT(*) AS TotalPedidos
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID 
WHERE p.FirstName LIKE 'A%' GROUP BY c.CustomerID, p.FirstName;

CREATE nonclustered index nc_Person
ON Person.Person (FirstName);

Create nonclustered index nc_SalesCustomer
on Sales.Customer (PersonID);
 
-- Consulta 7
SELECT TOP 100 sod.SalesOrderDetailID, sod.OrderQty,sod.UnitPrice,soh.OrderDate
FROM ( select top 100 SalesOrderID, ShipDate, OrderDate
from Sales.SalesOrderHeader order by ShipDate DESC)soh
JOIN Sales.SalesOrderDetail sod ON sod.SalesOrderID = soh.SalesOrderID
ORDER BY soh.ShipDate DESC, sod.OrderQty DESC, sod.UnitPrice DESC;

create nonclustered index nc_SalesOrderHeader
on Sales.SalesOrderHeader (ShipDate DESC, SalesOrderID)
include(OrderDate);

create nonclustered index nc_SalesOrderDetail
on Sales.SalesOrderDetail (SalesOrderID, OrderQty DESC,UnitPrice DESC)
include(SalesOrderDetailID);

--Consulta 8
SELECT p.ProductID, p.Name, SUM(sod.OrderQty) AS TotalVendido
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh 
    ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate >= '2014-01-01'
GROUP BY p.ProductID, p.Name
HAVING SUM(sod.OrderQty) > 100;

CREATE nonclustered index nc_SalesOrderDetail_Op
ON Sales.SalesOrderDetail (SalesOrderID) 
INCLUDE (ProductID, OrderQty);
