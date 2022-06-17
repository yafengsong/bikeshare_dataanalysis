-- 1. Combine all tables together
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202105`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202106`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202107`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202108`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202109`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202110`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202111`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202112`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202201`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202202`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202203`
UNION ALL
SELECT ride_id, rideable_type, started_at, ended_at, member_casual
FROM `automatic-asset-344814.cyclistic.tripdata_202204`

-- 2. Check the null values
SELECT *
FROM `automatic-asset-344814.cyclistic.aggregated` 
WHERE ride_id IS NULL
OR rideable_type IS NULL
OR started_at IS NULL
OR ended_at IS NULL
OR member_casual IS NULL

-- 3. Data Transformation and Cleaning
---- clean the ride_length < 0 data 
SELECT 
ride_id, rideable_type, started_at, ended_at, member_casual,
TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length,
EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week
FROM `automatic-asset-344814.cyclistic.aggregated` 
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >=0

-- 4. Count the day_of_week that people most likely to use our bicycle.
SELECT day_of_week, COUNT(*) AS count_day_of_week
FROM `automatic-asset-344814.cyclistic.aggregated_clean` 
GROUP BY day_of_week
ORDER BY count_day_of_week DESC

-- 5. Statistics of ride_length
SELECT 
MIN(ride_length) AS min_ride_length,
MAX(ride_length) AS max_ride_length,
AVG(ride_length) AS avg_ride_length
FROM `automatic-asset-344814.cyclistic.aggregated_clean` 

-- 6. Calculate the average ride length for casuals and members
SELECT member_casual, AVG(ride_length) AS avg_ride_length
FROM `automatic-asset-344814.cyclistic.aggregated_clean` 
GROUP BY member_casual

-- 7. Calculate the average ride length by day_of_week
SELECT day_of_week, AVG(ride_length) AS avg_ride_length
FROM `automatic-asset-344814.cyclistic.aggregated_clean` 
GROUP BY day_of_week
ORDER BY avg_ride_length DESC

-- 8. Calculate the number of rides by day_of_week
SELECT day_of_week, COUNT(*) AS num_of_rides
FROM `automatic-asset-344814.cyclistic.aggregated_clean` 
GROUP BY day_of_week
ORDER BY num_of_rides DESC

-- 9. Group the member type and bicycle type. 
SELECT member_casual, rideable_type, COUNT(*) AS num_of_rides
FROM `automatic-asset-344814.cyclistic.aggregated_clean` 
GROUP BY member_casual, rideable_type


-- 10. Gourp by member type
SELECT member_casual, COUNT(*) AS num_of_rides
FROM `automatic-asset-344814.cyclistic.aggregated_clean` 
GROUP BY member_casual

-- 11. Number of rides by month
SELECT num_of_rides, COUNT(*) AS num_rides_by_month
FROM
  (SELECT
  CASE 
    WHEN started_at BETWEEN '2021-05-01'AND '2021-05-31 23:59:59' THEN 1
    WHEN started_at BETWEEN '2021-06-01'AND '2021-06-30 23:59:59' THEN 2
    WHEN started_at BETWEEN '2021-07-01'AND '2021-07-31 23:59:59' THEN 3
    WHEN started_at BETWEEN '2021-08-01'AND '2021-08-31 23:59:59' THEN 4
    WHEN started_at BETWEEN '2021-09-01'AND '2021-09-30 23:59:59' THEN 5
    WHEN started_at BETWEEN '2021-10-01'AND '2021-10-31 23:59:59' THEN 6
    WHEN started_at BETWEEN '2021-11-01'AND '2021-11-30 23:59:59' THEN 7
    WHEN started_at BETWEEN '2021-12-01'AND '2021-12-31 23:59:59' THEN 8
    WHEN started_at BETWEEN '2022-01-01'AND '2022-01-31 23:59:59' THEN 9
    WHEN started_at BETWEEN '2022-02-01'AND '2022-02-28 23:59:59' THEN 10
    WHEN started_at BETWEEN '2022-03-01'AND '2022-03-31 23:59:59' THEN 11
    WHEN started_at BETWEEN '2022-04-01'AND '2022-04-30 23:59:59' THEN 12
    ELSE 0
  END AS num_of_rides
  FROM `automatic-asset-344814.cyclistic.aggregated_clean`)
GROUP BY num_of_rides

-- 11. Number of rides by month and by user type
SELECT num_of_rides, member_casual, COUNT(*) AS num_rides_by_month
FROM
  (SELECT member_casual,
  CASE 
    WHEN started_at BETWEEN '2021-05-01'AND '2021-05-31 23:59:59' THEN 1
    WHEN started_at BETWEEN '2021-06-01'AND '2021-06-30 23:59:59' THEN 2
    WHEN started_at BETWEEN '2021-07-01'AND '2021-07-31 23:59:59' THEN 3
    WHEN started_at BETWEEN '2021-08-01'AND '2021-08-31 23:59:59' THEN 4
    WHEN started_at BETWEEN '2021-09-01'AND '2021-09-30 23:59:59' THEN 5
    WHEN started_at BETWEEN '2021-10-01'AND '2021-10-31 23:59:59' THEN 6
    WHEN started_at BETWEEN '2021-11-01'AND '2021-11-30 23:59:59' THEN 7
    WHEN started_at BETWEEN '2021-12-01'AND '2021-12-31 23:59:59' THEN 8
    WHEN started_at BETWEEN '2022-01-01'AND '2022-01-31 23:59:59' THEN 9
    WHEN started_at BETWEEN '2022-02-01'AND '2022-02-28 23:59:59' THEN 10
    WHEN started_at BETWEEN '2022-03-01'AND '2022-03-31 23:59:59' THEN 11
    WHEN started_at BETWEEN '2022-04-01'AND '2022-04-30 23:59:59' THEN 12
    ELSE 0
  END AS num_of_rides
  FROM `automatic-asset-344814.cyclistic.aggregated_clean`)
GROUP BY num_of_rides, member_casual

-- 12. different user preference on day of week
SELECT member_casual, day_of_week, COUNT(*) AS num_of_rides
FROM `automatic-asset-344814.cyclistic.aggregated_clean`
GROUP BY member_casual, day_of_week
