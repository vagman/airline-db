-- Flights_View: 
CREATE VIEWS Flights_View AS
SELECT F.flight_id, F.departure_airport, Air.airport_name as departure_airport_name, F.arrival_airport, Air.airport_name as arrival_airport_name, Air.city, D.scheduled_departure_time, A.actual_departure_time, D.scheduled_arrival_time, A.actual_arrival_time, D.scheduled_duration
FROM flight as F natural join duration as D natural join actual_status as A natural join airport as Air
WHERE F.departure_date = '6/25/2022%';
-- 90% σωστο. TODO: Πρεπει να εμφανιζεται και το ΣΩΣΤΟ departure_airport_name and arrival_airport_name που αντιστοιχει στους κωδικους departure_aiport/arrival_airport


-- Routes_View: 
SELECT F.flight_id, F.departure_airport, Airp.airport_name as departure_airport_name, F.arrival_airport, Airp.airport_name as arrival_airport_name, Airp.city, Airc.aircraft_model, D.scheduled_duration
FROM flight as F 
join duration as D on F.flight_id = D.flight_id
join aircraft as Airc on F.aircraft_code= Airc.aircraft_code
join model as M on Airc.aircraft_model = M.aircraft_model
join airport as Airp on F.arrival_airport = Airp.airport_code
WHERE F.departure_date > '6/25/2022%' AND F.departure_date < '7/1/2022%';
-- 60% done. Να προστεθει μια ακομη στηλη οπου θα εχει τις ημερες τις εβδομαδας που τρεχει η πτηση δηλαδη "Μο -- -- -- -- -- --"
-- Δεν κολλαμε στο γεγονος οτι η καθε πτηση μας τρεχει μια ημερα μονο τυχαια αρκει να κανουμε convert την ημερομηνια (scheduled_departure_date)
-- σε Ημερα της εβδομαδα και να την περασουμε σε column.
