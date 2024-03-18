-- question 1

    CREATE MATERIALIZED VIEW trip_duration AS
    WITH tmp as
    (
    SELECT 
            tzp.Zone as pick_up_zone,
            tzd.Zone as drop_off_zone,
            tpep_dropoff_datetime - tpep_pickup_datetime as trip_duration
    FROM trip_data td
    JOIN taxi_zone tzd
        ON td.DOLocationID = tzd.location_id
   JOIN taxi_zone tzp
        ON td.PULocationID = tzp.location_id
    )
    SELECT
            pick_up_zone,
            drop_off_zone,
            avg(trip_duration) as avg_duration,
            max(trip_duration) as max_duration,
            min(trip_duration) as min_duration,
            count(trip_duration) as number_of_trips
    FROM tmp
    GROUP BY 1,2

    ;
    select * from trip_duration order by 3 desc limit 1;


-- question 2
    drop materialized view trip_duration;

     CREATE MATERIALIZED VIEW trip_duration AS
    WITH tmp as
    (
    SELECT 
            tzp.Zone as pick_up_zone,
            tzd.Zone as drop_off_zone,
            tpep_dropoff_datetime - tpep_pickup_datetime as trip_duration
    FROM trip_data td
    JOIN taxi_zone tzd
        ON td.DOLocationID = tzd.location_id
   JOIN taxi_zone tzp
        ON td.PULocationID = tzp.location_id
    )
    SELECT
            pick_up_zone,
            drop_off_zone,
            avg(trip_duration) as avg_duration,
            max(trip_duration) as max_duration,
            min(trip_duration) as min_duration,
            count(trip_duration) as number_of_trips
    FROM tmp
    GROUP BY 1,2;
    select * from trip_duration order by 3 desc limit 1;

-- question 3
    CREATE MATERIALIZED VIEW latest_pick AS
    SELECT MAX(tpep_pickup_datetime) AS latest_pickup_time
    FROM trip_data;

    SELECT 
            tz.Zone as taxi_zone,
            COUNT(tz.Zone) as number_of_pickups
    FROM latest_pick t, trip_data td 
    JOIN taxi_zone tz
        ON td.PULocationID = tz.location_id
    WHERE td.tpep_pickup_datetime >= t.latest_pickup_time - INTERVAL "17 HOURS"
    GROUP BY 1 
    ORDER BY 2 DESC
    limit 3;