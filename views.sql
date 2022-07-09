-- Flights_View: 
CREATE VIEW Flights_View AS
SELECT F.flight_id, F.departure_airport, DAir.airport_name as departure_airport_name, DAir.city AS departure_city, F.arrival_airport, AAir.airport_name as arrival_airport_name, AAir.city AS arrival_city, D.scheduled_departure_time, A.actual_departure_time, D.scheduled_arrival_time, A.actual_arrival_time, D.scheduled_duration, 
(SELECT (EXTRACT(epoch FROM(SELECT (A.actual_arrival_time - A.actual_departure_time)))/3600)::float) as actual_duration
FROM flight AS F 
JOIN duration AS D ON D.flight_id = F.flight_id
JOIN actual_status AS A ON A.flight_id = F.flight_id
JOIN airport AS DAir ON DAir.airport_code = F.departure_airport
JOIN airport AS AAir ON AAir.airport_code = F.arrival_airport
WHERE F.departure_date = '6/25/2022%';

-- Routes_View: 
CREATE VIEW Routes_View AS
SELECT F.flight_id, F.departure_airport, AAir.airport_name as departure_airport_name, F.arrival_airport, AAir.airport_name as arrival_airport_name, AAir.city, Airc.aircraft_model, D.scheduled_duration,
(SELECT to_char(F.departure_date, 'Day')) AS days_of_week
FROM flight as F 
join duration as D on F.flight_id = D.flight_id
join aircraft as Airc on F.aircraft_code= Airc.aircraft_code
join model as M on Airc.aircraft_model = M.aircraft_model
join airport as AAir on AAir.airport_code = F.arrival_airport
join airport as DAir on DAir.airport_code = F.arrival_airport
WHERE F.departure_date > '6/25/2022%' AND F.departure_date < '7/1/2022%';
