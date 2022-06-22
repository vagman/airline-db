CREATE TABLE IF NOT EXISTS booking
(
	book_ref VARCHAR(6),
	book_date TIMESTAMPTZ NOT NULL,
	total_cost DECIMAL(6,2) NOT NULL,

	CHECK (book_ref ~* '([a-z]|[A-Z]|\d){6}'), -- A combination of 6 digits or numbers
	CHECK (total_cost > 0),

	PRIMARY KEY (book_ref)
);

CREATE TABLE IF NOT EXISTS boarding_pass
(
	flight_id SERIAL,
	seat_no VARCHAR(3),
	boarding_no SERIAL NOT NULL,
	ticket_no VARCHAR(13) NOT NULL UNIQUE,

	PRIMARY KEY (flight_id, seat_no)
);

CREATE TABLE IF NOT EXISTS ticket
(
	ticket_no VARCHAR(13),
	amount DECIMAL(6,2) NOT NULL,
	fare VARCHAR(11) NOT NULL,
	book_ref VARCHAR(6) NOT NULL UNIQUE,
	flight_id INT NOT NULL UNIQUE,
	passenger_id VARCHAR(10) NOT NULL UNIQUE,

	CHECK (ticket_no ~* '^\d{13}$'), -- It has to be a 13-digit number
	CHECK (fare IN ('Economy', 'Business', 'First class')),
	CHECK (book_ref ~* '([a-z]|[A-Z]|\d){6}'),
	CHECK (amount > 0),

	FOREIGN KEY (ticket_no) REFERENCES boarding_pass(ticket_no) ON DELETE CASCADE,
	FOREIGN KEY (book_ref) REFERENCES booking(book_ref) ON DELETE CASCADE,
	PRIMARY KEY (ticket_no)
);

CREATE TABLE IF NOT EXISTS passenger
(
	passenger_id VARCHAR(10),
	passenger_name VARCHAR(100),
	contact_data VARCHAR(100),

	PRIMARY KEY (passenger_id),
	FOREIGN KEY (passenger_id) REFERENCES ticket(passenger_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS flight
(
	flight_id SERIAL,
	arrival_airport VARCHAR(100), -- May need a trigger
	departure_airport VARCHAR(100), -- May need a trigger
	departure_date DATE, -- May need a trigger
	airplane_model VARCHAR(40) NOT NULL,
	distance NUMERIC(4,0) NOT NULL,
	scheduled_departure_time TIMESTAMPTZ NOT NULL,
	scheduled_arrival_time TIMESTAMPTZ NOT NULL,
	scheduled_duration numeric(4,2), -- NOT NULL generated always as ( extract(epoch from (scheduled_arrival_time - scheduled_departure_time))/3600 ) stored,
	actual_departure_time TIMESTAMPTZ,
	actual_arrival_time TIMESTAMPTZ,
	flight_status VARCHAR(9) NOT NULL,
	aircraft_code VARCHAR(3) NOT NULL UNIQUE,

	CHECK (arrival_airport != departure_airport), -- May need a trigger
	CHECK ((actual_arrival_time IS NULL) OR ((actual_departure_time IS NOT NULL AND  actual_arrival_time IS NOT NULL) AND (scheduled_arrival_time > scheduled_departure_time))),
	CHECK (flight_status IN ('Scheduled', 'OnTime', 'Delayed', 'Departed', 'Arrived', 'Cancelled')),

	FOREIGN KEY (flight_id) REFERENCES ticket(flight_id) ON DELETE CASCADE,
	FOREIGN KEY(arrival_airport), 
	FOREIGN KEY(departure_airport) REFERENCES airport(airport_code) ON DELETE CASCADE,
	PRIMARY KEY (flight_id)
);

CREATE TABLE IF NOT EXISTS aircraft
(
	aircraft_code VARCHAR(3),
	model VARCHAR(40) NOT NULL,
	capacity INT NOT NULL,
	aircraft_range NUMERIC(4,0) NOT NULL, 

	CHECK (aircraft_code ~* '^\d{3}$'), -- It has to be a 3-digit number
	CHECK (capacity > 0),
	CHECK (aircraft_range > 0),

	FOREIGN KEY (aircraft_code) REFERENCES flight(aircraft_code) ON DELETE CASCADE,
	FOREIGN KEY (aircraft_code) REFERENCES boarding_pass(aircraft_code) ON DELETE CASCADE,
	PRIMARY KEY (aircraft_code)
);

CREATE TABLE IF NOT EXISTS airport
(
	airport_code VARCHAR(3),
	airport_name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
	timezone TIMESTAMPTZ NOT NULL,

	CHECK (airport_code ~* '^\w{3}$'), -- It has to be a 3 letters

	FOREIGN KEY (airport_code) REFERENCES flight(airport_code) ON DELETE CASCADE,
	PRIMARY KEY (airport_code)
);

-- Sample data
COPY booking FROM '/booking.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM booking;

COPY flight FROM '/flight.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM flight;

COPY airport FROM '/airport.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM airport;

COPY aircraft FROM '/aircraft.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM aircraft;

COPY ticket FROM '/ticket.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM ticket;

COPY boarding_pass FROM '/boarding_pass.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM boarding_pass;