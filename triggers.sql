-- Here we will implement Ερώτημα 3 (20%) - Triggers

-- Check that the aircraft_distance is greater than flight.distance
CREATE FUNCTION flight_distance() RETURNS trigger AS $flight_distance$
    BEGIN
        IF NEW.aircraft.aircraft_distance < NEW.flight.distance THEN
            RAISE EXCEPTION '% cannot have a flight distance with less that the aircrafts distance', NEW.;
        END IF;
    END;
$flight_distance$ LANGUAGE plpgsql;

CREATE TRIGGER flight_distance BEFORE INSERT OR UPDATE 
ON flight FOR EACH ROW EXECUTE PROCEDURE flight_distance();
