USE covidHistorico2;
GO

-- 1. CREAR NUEVOS FILEGROUPS (Para 2020 y 2021)
ALTER DATABASE Covidhistorico2 ADD FILEGROUP FG_ANTES_2020;
ALTER DATABASE Covidhistorico2 ADD FILEGROUP FG_2020;
ALTER DATABASE Covidhistorico2 ADD FILEGROUP FG_2021;
ALTER DATABASE Covidhistorico2 ADD FILEGROUP FG_2022_MAS;
GO

-- 2. CREAR NUEVOS ARCHIVOS FÍSICOS
ALTER DATABASE CovidHistorico2 
ADD FILE (NAME = FG_ANTES_2020_v2, FILENAME = 'C:\Dataa\FG_ANTES_2020.ndf') 
TO FILEGROUP FG_ANTES_2020;

ALTER DATABASE CovidHistorico2
ADD FILE (NAME = FG_2020_v2, FILENAME = 'C:\Dataa\FG_2020.ndf')
TO FILEGROUP FG_2020;

ALTER DATABASE CovidHistorico2
ADD FILE (NAME = FG_2021_v2, FILENAME = 'C:\Dataa\FG_2021.ndf')
TO FILEGROUP FG_2021;

ALTER DATABASE CovidHistorico2
ADD FILE (NAME = FG_2022_MAS_v2, FILENAME = 'C:\Dataa\FG_2022_MAS.ndf')
TO FILEGROUP FG_2022_MAS;
GO

-- 3. CREAR FUNCIÓN DE PARTICIONAMIENTO
CREATE PARTITION FUNCTION pf_anio (DATE)
AS RANGE RIGHT FOR VALUES 
('2020-01-01', '2021-01-01', '2022-01-01');
GO

-- 4. CREAR ESQUEMA
CREATE PARTITION SCHEME ps_anio
AS PARTITION pf_anio
TO (
    FG_ANTES_2020,  -- Partición 1: < 2020
    FG_2020,        -- Partición 2: Todo el 2020
    FG_2021,        -- Partición 3: Todo el 2021
    FG_2022_MAS     -- Partición 4: >= 2022
);
GO

-- 5. CREAR LA TABLA Y EL ÍNDICE
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
SELECT pf.name, prv.value
FROM sys.partition_functions pf
JOIN sys.partition_range_values prv 
    ON pf.function_id = prv.function_id
WHERE pf.name = 'pf_anio';

SELECT 
    p.partition_number,
    p.rows
FROM sys.partitions p
WHERE p.object_id = OBJECT_ID('covid_particionado')
AND p.index_id IN (0,1);