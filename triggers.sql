--Ερώτημα 3 (20%). Υλοποίηση triggers, cursors

-- Φτιάξτε έναν trigger ο οποίος κρατά/γεμίζει ένα πίνακα-ιστορικό. Ο trigger
-- ενεργοποιείται στις μεταβολές διαγραφή και ενημέρωση του κύριου πίνακα.
-- Όταν διαγράφονται με επιτυχία γραμμές από τον πίνακα booking (π.χ. διαγράφονται όλες
-- οι εγγραφές με ημερομηνία μικρότερη του 1970-01-01 00:00:00), τότε οι διαγραμμένες
-- γραμμές εισάγονται αυτόματα στον πίνακα booking-log. Όταν πραγματοποιείται μια
-- ενημέρωση μιας τιμής στον κύριο πίνακα booking, τότε ο trigger ενεργοποιείται και
-- καταγράφει την παλιά εγγραφή στον πίνακα booking-log. Ιδανικά μαζί με τη
-- μεταβαλλόμενη εγγραφή καταγράφει και την ημερομηνία και ώρα της αλλαγής καθώς και
-- το είδος της μεταβολής (d-για delete και u-για update).


ON aircraft, flight 
FOR EACH ROW
aircraft.aircraft_range > flight.flight_range;

CREATE FUNCTION flight_duration RETURN TRIGGER AS $calculate_flight_duration$
    BEGIN
        
    END;
LANGUAGE plpgsql;


CREATE TRIGGER create_history_table BEFORE DELETE OR UPDATE