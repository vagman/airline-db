-- Check that the aircraft.aircraft_range > flight.flight_distance
CREATE TRIGGER check_flight_distance
BEFORE INSERT
ON aircraft, flight 
FOR EACH ROW
aircraft.aircraft_range > flight.flight_range;

-- Create a trigger to calculate the scheduled duration of each flight
CREATE FUNCTION flight_duration RETURN TRIGGER AS $calculate_flight_duration$
    BEGIN
        -- |scheduled_arrival_time - scheduled_departure_time|
    END;
LANGUAGE plpgsql;

CREATE TRIGGER calculate_flight_duration
BEFORE INSERT ON flight FOR EACH ROW EXECUTE FUNCTION flight_duration();
