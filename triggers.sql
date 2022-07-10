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
	action_timestamp TIMESTAMPTZ,
	
	PRIMARY KEY (log_id)
);

CREATE OR REPLACE FUNCTION logger() RETURNS TRIGGER AS $insert_into_log_table$
    BEGIN
    -- Identify the trigger operation through TG_OP
	IF (TG_OP = 'DELETE') THEN
        INSERT INTO booking_log VALUES (DEFAULT, OLD.book_ref, OLD.book_date, OLD.total_cost, 'd', now());
	-- Updated row has new data stored and not the same as before!
    ELSIF (TG_OP = 'UPDATE' AND OLD.* IS DISTINCT FROM NEW.*) THEN
		INSERT INTO booking_log VALUES (DEFAULT, OLD.book_ref, OLD.book_date, OLD.total_cost, 'u', now());
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

