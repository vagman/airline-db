-- 1. Ποιος ταξίδεψε με μια συγκεκριμένη πτήση (π.χ. PG0404) χθες στη θέση 1A και πότε έγινε
-- η κράτηση του εισιτηρίου; Η χθεσινή ημερομηνία θα υπολογίζεται με βάση την
-- ημερομηνία εκτέλεσης του ερωτήματος.
SELECT P.passenger_id, P.passenger_name, B.book_date
FROM flight AS F 
JOIN ticket AS T ON F.flight_id = T.flight_id
JOIN booking AS B ON T.book_ref = B.book_ref
JOIN passenger AS P ON T.passenger_id = P.passenger_id
JOIN boarding_pass AS BP ON T.ticket_no = BP.ticket_no
WHERE F.flight_id = 33 
	AND BP.seat_no = '1A' 
	AND B.book_date = CURRENT_DATE - 1;

-- 2.

-- 3.

-- 4.

-- 5.

-- 6.