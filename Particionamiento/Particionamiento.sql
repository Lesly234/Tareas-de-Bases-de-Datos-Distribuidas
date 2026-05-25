USE covidHistorico2;
GO

-- 1. CREAR FILEGROUPS
ALTER DATABASE Covidhistorico2 ADD FILEGROUP FG_ANTES_2021;
ALTER DATABASE Covidhistorico2 ADD FILEGROUP FG_2021;
ALTER DATABASE CovidHistorico2 ADD FILEGROUP FG_2022;
ALTER DATABASE Covidhistorico2 ADD FILEGROUP FG_2023_MAS;
GO

-- 2. CREAR ARCHIVOS FÍSICOS (.ndf) Y ASIGNARLOS A LOS FILEGROUPS
ALTER DATABASE CovidHistorico2 
ADD FILE (NAME = FG_ANTES_2021_dat, FILENAME = 'C:\Data\FG_ANTES_2021.ndf') 
TO FILEGROUP FG_ANTES_2021;

ALTER DATABASE CovidHistorico2
ADD FILE (NAME = FG_2021_dat, FILENAME = 'C:\Data\FG_2021.ndf')
TO FILEGROUP FG_2021;

ALTER DATABASE CovidHistorico2
ADD FILE (NAME = FG_2022_dat, FILENAME = 'C:\Data\FG_2022.ndf')
TO FILEGROUP FG_2022;

ALTER DATABASE CovidHistorico2
ADD FILE (NAME = FG_2023_MAS_dat, FILENAME = 'C:\Data\FG_2023_MAS.ndf')
TO FILEGROUP FG_2023_MAS;
GO

-- 3. CREAR FUNCIÓN DE PARTICIONAMIENTO
CREATE PARTITION FUNCTION pf_anio (DATE)
AS RANGE RIGHT FOR VALUES 
('2021-01-01', '2022-01-01', '2023-01-01');
GO

-- 4. CREAR ESQUEMA DE PARTICIONAMIENTO Mapeando a tus Filegroups
CREATE PARTITION SCHEME ps_anio
AS PARTITION pf_anio
TO (
    FG_ANTES_2021,  
    FG_2021,        
    FG_2022,        
    FG_2023_MAS     
);
GO

-- 5. CREAR LA TABLA USANDO EL ESQUEMA
CREATE TABLE covid_particionado (
    FECHA_INGRESO DATE,
    ENTIDAD_RES VARCHAR(50),
    EDAD INT
)
ON ps_anio(FECHA_INGRESO);
GO

CREATE CLUSTERED INDEX idx_fecha
ON covid_particionado(FECHA_INGRESO)
ON ps_anio(FECHA_INGRESO);
GO

-- 6. INSERCIÓN DE DATOS
INSERT 
INTO covid_particionado (FECHA_INGRESO, ENTIDAD_RES, EDAD)
SELECT 
    TRY_CONVERT(DATE, REPLACE(Fecha_ingreso,'"','')),
    REPLACE(ENTIDAD_RES,'"',''),
    TRY_CONVERT(INT, REPLACE(EDAD,'"',''))
FROM datoscovid
WHERE TRY_CONVERT(DATE, REPLACE(FECHA_INGRESO,'"','')) IS NOT NULL;
GO

-- 7. CONSULTAS DE VERIFICACIÓN
-- rangos por partición
SELECT pf.name, prv.value
FROM sys.partition_functions pf
JOIN sys.partition_range_values prv 
    ON pf.function_id = prv.function_id
WHERE pf.name = 'pf_anio';

-- Filas por particiones 
SELECT 
    p.partition_number,
    p.rows
FROM sys.partitions p
WHERE p.object_id = OBJECT_ID('covid_particionado')
AND p.index_id IN (0,1);

-- detalles partición
SELECT 
    t.name AS Tabla,
    i.name AS Indice,
    p.partition_number,
    p.rows
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
WHERE t.name = 'covid_particionado';