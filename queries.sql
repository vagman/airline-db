-- a. Ποιος ταξίδεψε με μια συγκεκριμένη πτήση (π.χ. PG0404) χθες στη θέση 1A και πότε έγινε
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

-- b.
SELECT M.capacity AS total_seats, COUNT(*) AS reserved_seats, M.capacity - COUNT(*) AS blank_seats
FROM boarding_pass AS B
JOIN flight AS F ON F.flight_id = B.flight_id
JOIN aircraft AS A ON A.aircraft_code = F.aircraft_code
JOIN model AS M ON M.aircraft_model = A.aircraft_model
WHERE B.flight_id = 33
GROUP BY M.capacity;

-- c.
SELECT F.flight_id, A.actual_arrival_time - A.actual_departure_time AS delay NOT NULL
FROM flight AS F
JOIN actual_status AS A ON A.flight_id = F.flight_id
WHERE EXTRACT(YEAR FROM F.departure_date) = 2022
ORDER BY delay ASC;

-- d.
SELECT F.flight_id, (SELECT (EXTRACT(epoch FROM(SELECT (A.actual_arrival_time - A.actual_departure_time)))/3600)::float) AS delay_in_hours, F.departure_date 
FROM flight AS F
JOIN actual_status AS A ON A.flight_id = F.flight_id
WHERE EXTRACT(YEAR FROM F.departure_date) = 2022
	  AND (SELECT (EXTRACT(epoch FROM(SELECT (A.actual_arrival_time - A.actual_departure_time)))/3600)::float) IS NOT NULL
ORDER BY delay_in_hours DESC
LIMIT 5;

-- e.

-- f.
SELECT flight_id
FROM ticket AS T 
JOIN boarding_pass AS B ON B.flight_id = T.flight_id
JOIN flight AS F ON f.flight_ID = t.flight_id
JOIN passenger AS P ON T.passenger_id = P.passenger_id
WHERE 
ORDER BY boarding_no DESC;

