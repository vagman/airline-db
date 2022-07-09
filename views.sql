-- Flights_View: 
CREATE VIEW Flights_View AS
SELECT F.flight_id, F.departure_airport, DAir.airport_name AS departure_airport_name, DAir.city AS departure_city, F.arrival_airport, AAir.airport_name AS arrival_airport_name, AAir.city AS arrival_city, D.scheduled_departure_time, A.actual_departure_time, D.scheduled_arrival_time, A.actual_arrival_time, D.scheduled_duration, 
(SELECT (EXTRACT(epoch FROM(SELECT (A.actual_arrival_time - A.actual_departure_time)))/3600)::float) AS actual_duration
FROM flight AS F 
JOIN duration AS D ON D.flight_id = F.flight_id
JOIN actual_status AS A ON A.flight_id = F.flight_id
JOIN airport AS DAir ON DAir.airport_code = F.departure_airport
JOIN airport AS AAir ON AAir.airport_code = F.arrival_airport
WHERE F.departure_date = '6/25/2022%';

-- Routes_View: 
CREATE VIEW Routes_View AS
SELECT F.flight_id, F.departure_airport, AAir.airport_name AS departure_airport_name, F.arrival_airport, AAir.airport_name AS arrival_airport_name, AAir.city, Airc.aircraft_model, D.scheduled_duration,
(SELECT to_char(F.departure_date, 'Day')) AS days_of_week
FROM flight AS F 
JOIN duration AS D ON F.flight_id = D.flight_id
JOIN aircraft AS Airc ON F.aircraft_code= Airc.aircraft_code
JOIN model AS M ON Airc.aircraft_model = M.aircraft_model
JOIN airport AS AAir ON AAir.airport_code = F.arrival_airport
JOIN airport AS DAir ON DAir.airport_code = F.arrival_airport
WHERE F.departure_date > '6/25/2022%' AND F.departure_date < '7/1/2022%';
