--Ερώτημα 3 (20%). Υλοποίηση triggers, cursors

-- a. Φτιάξτε έναν trigger ο οποίος κρατά/γεμίζει ένα πίνακα-ιστορικό. Ο trigger
-- ενεργοποιείται στις μεταβολές διαγραφή και ενημέρωση του κύριου πίνακα.
-- Όταν διαγράφονται με επιτυχία γραμμές από τον πίνακα booking (π.χ. διαγράφονται όλες
-- οι εγγραφές με ημερομηνία μικρότερη του 1970-01-01 00:00:00), τότε οι διαγραμμένες
-- γραμμές εισάγονται αυτόματα στον πίνακα booking-log. Όταν πραγματοποιείται μια
-- ενημέρωση μιας τιμής στον κύριο πίνακα booking, τότε ο trigger ενεργοποιείται και
-- καταγράφει την παλιά εγγραφή στον πίνακα booking-log. Ιδανικά μαζί με τη
-- μεταβαλλόμενη εγγραφή καταγράφει και την ημερομηνία και ώρα της αλλαγής καθώς και
-- το είδος της μεταβολής (d-για delete και u-για update).
CREATE TABLE booking_log
(
	log_id SERIAL,
    log_book_ref VARCHAR(6),
	log_book_date DATE NOT NULL,
	log_total_cost MONEY NOT NULL,
	action_called varchar(1),
	action_timestamp TIMESTAMP,
	
	PRIMARY KEY (log_id)
);

CREATE OR REPLACE FUNCTION logger() RETURNS TRIGGER AS $insert_into_log_table$
    BEGIN
    -- Identify the trigger operation through TG_OP
	IF (TG_OP = 'DELETE') THEN
		raise notice 'DELETE query was executed sucessfully to booking table. Inserting log data into booking_log table';
        INSERT INTO booking_log VALUES (DEFAULT, OLD.book_ref, OLD.book_date, OLD.total_cost, 'd', now()::date + to_char(now()::time, 'HH24:MI')::time);
	-- Updated row has new data stored and not the same as before!
    ELSIF (TG_OP = 'UPDATE' AND OLD.* IS DISTINCT FROM NEW.*) THEN
		raise notice 'UPDATE query was executed sucessfully to booking table. Inserting log data into booking_log table';
		INSERT INTO booking_log VALUES (DEFAULT, OLD.book_ref, OLD.book_date, OLD.total_cost, 'u', now()::date + to_char(now()::time, 'HH24:MI')::time);
	END IF;
	RETURN NEW;
    END 
$insert_into_log_table$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER insert_into_log_table 
    BEFORE DELETE OR UPDATE ON booking 
    FOR EACH ROW
    EXECUTE FUNCTION logger();

-- Update example on Booking table..
UPDATE booking
SET total_cost = '$11,0100'
WHERE book_ref = '000P61';

-- Delete example on  Booking table..
DELETE FROM booking
WHERE book_ref = '000X89';

-- The affected rows are sucessfully inserted into booking_log!
select * from booking_log;

-- b. Βρείτε και εμφανίστε τα στοιχεία ημερομηνία αναχώρησης, ημερομηνία άφιξης, όνομα
-- αεροδρομίου, κωδικός πτήσης, όνομα επιβάτη, ομαδοποιημένα ανά όνομα επιβάτη και
-- ημερομηνία αναχώρησης. Χρησιμοποιείστε cursors ώστε να εμφανίσετε τις γραμμές σε
-- ομάδες των 15.
CREATE OR REPLACE FUNCTION get_passenger_cursor()
RETURNS table(passenger_name VARCHAR(100), 
			  scheduled_departure_time timestamptz, 
			  scheduled_arrival_time timestamptz, 
			  departure_date DATE, 
			  departure_airport VARCHAR(3),
			  arrival_airport VARCHAR(3), 
			  flight_id int
			 )
as $$
	declare
		cursor_passenger cursor;

	begin 
		-- open the cursor
		open cursor_passenger;

		return query
		SELECT P.passenger_name, D.scheduled_departure_time, D.scheduled_arrival_time, F.departure_date, F.departure_airport, F.arrival_airport, F.flight_id
		FROM  flight AS F
		JOIN duration AS D ON D.flight_id = F.flight_id
		JOIN airport AS AAir ON Aair.airport_code = F.arrival_airport
		JOIN airport AS DAir ON Dair.airport_code = F.departure_airport
		JOIN ticket AS T ON T.flight_id = F.flight_id
		JOIN passenger AS P ON P.passenger_id = T.passenger_id 
		GROUP BY P.passenger_name, D.scheduled_departure_time, F.departure_date, F.departure_airport, F.arrival_airport, F.flight_id, D.scheduled_arrival_time;
	end; $$
	-- close the cursor
	close cursor_passenger;
LANGUAGE plpgsql;

SELECT get_passenger_cursor();
