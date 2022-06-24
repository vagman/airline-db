-- Check that the aircraft_distance is greater than flight.distance
CREATE TRIGGER check_flight_distance
BEFORE INSERT
ON aircraft, flight 
FOR EACH ROW
aircraft.aircraft_distance > flight.flight_range;

-- Create a trigger to calculate the scheduled duration of each flight
CREATE TRIGGER calculate_flight_duration
BEFORE INSERT
ON flight
FOR EACH ROW
execute Procedure flight_duration();
