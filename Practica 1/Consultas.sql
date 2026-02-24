use AdventureWorks2022
/*Ejercicio 1. Encuentra los 10 productos más vendidos en 2014, mostrando nombre del producto, 
cantidad total vendida y nombre del cliente.*/
WITH PRODUCTOS AS (
    SELECT TOP 10 
     V.ProductID,
    SUM(V.OrderQty) AS Cantidad_Total
    FROM Sales.SalesOrderDetail AS V
    JOIN Production.Product AS P
    ON V.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS H
    ON H.SalesOrderID = V.SalesOrderID
    WHERE YEAR(H.OrderDate) = 2014
    GROUP BY V.ProductID
    ORDER BY SUM(V.OrderQty) DESC
)
SELECT DISTINCT
    P.Name AS Nombre_Producto,
    T.Cantidad_Total,
    E.FirstName AS Nombre_Cliente
FROM PRODUCTOS AS T
JOIN Production.Product AS P
 ON T.ProductID = P.ProductID
JOIN Sales.SalesOrderDetail AS V
 ON T.ProductID = V.ProductID
JOIN Sales.SalesOrderHeader AS H
 ON V.SalesOrderID = H.SalesOrderID
JOIN Sales.Customer AS C
 ON H.CustomerID = C.CustomerID
JOIN Person.Person AS E
 ON C.PersonID = E.BusinessEntityID
ORDER BY T.Cantidad_Total DESC;


/*Una vez resuelta la consulta: agrega el precio unitario promedio (AVG(UnitPrice)) y filtra solo productos con ListPrice > 1000.*/

WITH TopProductos AS (
SELECT TOP 10 
V.ProductID,
SUM(V.OrderQty) AS Cantidad_Total,
AVG(V.UnitPrice) AS Precio_Unitario
FROM Sales.SalesOrderDetail AS V
JOIN Production.Product AS P
ON V.ProductID = P.ProductID
JOIN Sales.SalesOrderHeader AS H
ON H.SalesOrderID = V.SalesOrderID
WHERE YEAR(H.OrderDate) = 2014
AND P.ListPrice > 1000
GROUP BY V.ProductID
ORDER BY SUM(V.OrderQty) DESC
)
SELECT DISTINCT
P.Name AS Nombre_Producto,
T.Cantidad_Total,
T.Precio_Unitario,
E.FirstName AS Nombre_Cliente
FROM TopProductos AS T
JOIN Production.Product AS P
ON T.ProductID = P.ProductID
JOIN Sales.SalesOrderDetail AS V
ON T.ProductID = V.ProductID
JOIN Sales.SalesOrderHeader AS H
ON V.SalesOrderID = H.SalesOrderID
JOIN Sales.Customer AS C
ON H.CustomerID = C.CustomerID
JOIN Person.Person AS E
ON C.PersonID = E.BusinessEntityID
ORDER BY T.Cantidad_Total DESC;



/* Ejercicio 2: Lista los empleados que han vendido más que el promedio de ventas por empleado en 
el territorio 'Northwest'.*/
/*1. Requisito adicional: aplicar subconsultas.*/ 
select
    p.FirstName,
    p.LastName,
    e.SalesYTD
from
    Sales.SalesPerson AS e
    inner join
    Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
    where  e.SalesYTD> (select  AVG(sp.SalesYTD) from Sales.SalesPerson as sp
    inner join Sales.SalesTerritory as st ON sp.TerritoryID=st.TerritoryID
    where  st.Name='Northwest')
    and e.TerritoryID = (SELECT TerritoryID FROM Sales.SalesTerritory WHERE Name = 'Northwest');

    /*2. Una vez resuelta la consulta convierte la subconsulta en un CTE (Common Table Expresión).*/

    WITH Promedio as (select  AVG(sp.SalesYTD) ValorPromedio from Sales.SalesPerson as sp
    INNER JOIN Sales.SalesTerritory as st ON sp.TerritoryID=st.TerritoryID
    where  st.Name='Northwest'
    )
    SELECT 
    p.FirstName,
    p.LastName,
    e.SalesYTD
FROM 
    Sales.SalesPerson AS e
    INNER JOIN 
    Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
    where  e.SalesYTD> (select  ValorPromedio from Promedio)/*CTE*/
       AND e.TerritoryID = (SELECT TerritoryID FROM Sales.SalesTerritory WHERE Name = 'Northwest');


/* Ejercicio 3: Calcula ventas totales por territorio y año, mostrando solo aquellos con más de 5 órdenes 
y ventas > $1,000,000, ordenado por ventas descendente.*/
select 
year(ve.OrderDate) as Fecha,
te.Name Territorio,
COUNT(ve.SalesOrderID) as OrdenesTotales,
SUM(ve.TotalDue) as TotalVentas,
STDEV(ve.TotalDue) AS DesviacionVentas
from Sales.SalesOrderHeader as ve
inner join Sales.SalesTerritory as te on ve.TerritoryID=te.TerritoryID
GROUP BY YEAR(ve.OrderDate), te.Name
HAVING COUNT(ve.SalesOrderID)>'5' AND SUM(ve.TotalDue)>'1000000'
order by totalVentas DESC;

/*Ejercicio 4:  Encuentra vendedores que han vendido TODOS los productos de la categoría "Bikes".*/
SELECT DISTINCT Per.FirstName AS Vendedor
FROM Sales.SalesPerson SP
JOIN Person.Person Per
ON SP.BusinessEntityID = Per.BusinessEntityID
WHERE NOT EXISTS 
(SELECT P.ProductID
FROM Production.Product P
JOIN Production.ProductSubcategory PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC
ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE PC.Name = 'Bikes'
AND NOT EXISTS 
(SELECT *
FROM Sales.SalesOrderHeader H
JOIN Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
WHERE H.SalesPersonID = SP.BusinessEntityID
AND D.ProductID = P.ProductID)
);
/*Cambia a categoría "Clothing" (ID=4).*/
WHERE PC.Name = 'Accsessories'
/*Cuenta cuántos productos por categoría maneja cada vendedor.*/

SELECT 
    Per.FirstName AS Vendedor,
    PC.Name AS Categoria,
    COUNT(DISTINCT P.ProductID) AS Total_Productos
FROM Sales.SalesPerson SP
JOIN Person.Person Per
    ON SP.BusinessEntityID = Per.BusinessEntityID
JOIN Sales.SalesOrderHeader H
    ON H.SalesPersonID = SP.BusinessEntityID
JOIN Sales.SalesOrderDetail D
    ON D.SalesOrderID = H.SalesOrderID
JOIN Production.Product P
    ON P.ProductID = D.ProductID
JOIN Production.ProductSubcategory PS
    ON PS.ProductSubcategoryID = P.ProductSubcategoryID
JOIN Production.ProductCategory PC
    ON PC.ProductCategoryID = PS.ProductCategoryID
GROUP BY 
    Per.FirstName,
    PC.Name
ORDER BY 
    Per.FirstName,
    PC.Name;

/*Ejercicio 5: Determinar el producto más vendido de cada categoría de producto, considerando el 
escenario de que el esquema SALES se encuentra en una instancia (servidor) A y el esquema 
PRODUCTION en otra instancia (servidor) B.*/
    WITH VentasRanking AS (
    SELECT 
        cat.Name AS Categoria,
        prod.Name AS Producto,
        SUM(det.OrderQty) AS TotalVendido,
        ROW_NUMBER() OVER(
            PARTITION BY cat.Name 
            ORDER BY SUM(det.OrderQty) DESC
        ) AS TopRanking
    FROM Sales.SalesOrderDetail AS det
    -- Unión con el servidor remoto (Servidor B)
    INNER JOIN [SV_SELF].[AdventureWorks2022].[Production].[Product] AS prod 
        ON det.ProductID = prod.ProductID
    INNER JOIN [SV_SELF].[AdventureWorks2022].[Production].[ProductSubcategory] AS sub 
        ON prod.ProductSubcategoryID = sub.ProductSubcategoryID
    INNER JOIN [SV_SELF].[AdventureWorks2022].[Production].[ProductCategory] AS cat 
        ON sub.ProductCategoryID = cat.ProductCategoryID
    GROUP BY cat.Name, prod.Name
)
SELECT 
    Categoria, 
    Producto, 
    TotalVendido
FROM VentasRanking
WHERE TopRanking = 1
ORDER BY TotalVendido DESC;

EXEC sp_addlinkedserver 
   @server = 'SV_LES', 
   @srvproduct = 'SQLServer',              -- Lo dejamos vacío para que acepte el proveedor
   @provider = 'MSOLEDBSQL',      -- Especificamos el proveedor que SQL pedía
   @datasrc = @@SERVERNAME;       -- @@SERVERNAME obtiene el nombre de tu PC automáticamente

-- 3. Configuramos las credenciales (usando las tuyas actuales)
EXEC sp_addlinkedsrvlogin 
   @rmtsrvname = 'SV_LES', 
   @useself = 'true';
   SELECT * FROM SV_SELF.master.sys.databases;