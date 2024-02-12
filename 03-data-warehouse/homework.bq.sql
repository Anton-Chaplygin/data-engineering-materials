-- 1
CREATE OR REPLACE EXTERNAL TABLE mage.green_taxi_2022_ext
OPTIONS (
  format = 'parquet',
  uris = ['gs://mage-de-zoomcamp-green-taxi/green_taxi_2022/*']
);

-- 2
CREATE OR REPLACE TABLE mage.green_taxi_2022_int
AS
SELECT * FROM mage.green_taxi_2022_ext
;



-- Question 1: 840,402
SELECT count(*) 
FROM mage.green_taxi_2022_ext
;

-- Question 2: ( 0 and 6.41)
SELECT COUNT(DISTINCT(lpep_pickup_datetime))
FROM mage.green_taxi_2022_ext
;
SELECT COUNT(DISTINCT(lpep_pickup_datetime))
FROM mage.green_taxi_2022_int
;

-- Question 3: 1,622
SELECT count(*)
FROM mage.green_taxi_2022_ext
WHERE TRUE
    AND fare_amount = 0
;

-- Question 4: Partition by lpep_pickup_datetime Cluster on PUlocationID
CREATE OR REPLACE TABLE mage.green_taxi_2022_int_optimized
    PARTITION BY DATE(lpep_pickup_datetime)
    CLUSTER BY pulocationid
    AS
SELECT * FROM mage.green_taxi_2022_ext
;

-- Question 5: 12.82 MB for non-partitioned table and 1.12 MB for the partitioned table
SELECT DISTINCT
        pulocationid
FROM mage.green_taxi_2022_int
-- FROM mage.green_taxi_2022_int_optimized
WHERE TRUE
    AND DATE(lpep_pickup_datetime) >= '2022-06-01'
    AND DATE(lpep_pickup_datetime) <= '2022-06-30'
;

-- Question 6: GCP Bucket

-- Question 7: True

-- Question 8 (Bonus): True
SELECT COUNT(*)
FROM mage.green_taxi_2022_int
-- FROM mage.green_taxi_2022_int_optimized
;













