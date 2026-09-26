
/*FRAGMENTO 1: NORTE*/
SELECT *
FROM Sales.Customer
WHERE CustomerID >= 1 AND CustomerID <= 6024;

/*FRAGMENTO 2: SUR*/
SELECT *
FROM Sales.Customer
WHERE CustomerID > 6024 AND CustomerID <= 12048;

/*FRAGMENTO 3: ESTE*/
SELECT *
FROM Sales.Customer
WHERE CustomerID > 12048 AND CustomerID <= 18072;

/*FRAGMENTO 4: OESTE*/ 
SELECT *
FROM Sales.Customer
WHERE CustomerID > 18072 AND CustomerID <= 24096;

/*FRAGMENTO 5: CENTRO*/
SELECT *
FROM Sales.Customer
WHERE CustomerID > 24096 AND CustomerID <= 30118;