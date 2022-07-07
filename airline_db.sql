DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE booking
(
	book_ref VARCHAR(6),
	book_date DATE NOT NULL,
	total_cost MONEY NOT NULL,

	CHECK (book_ref ~* '([a-z]|[A-Z]|\d){6}'),
	CHECK (total_cost::numeric::int > 0),

	PRIMARY KEY (book_ref)
);

CREATE TABLE model
(
	aircraft_model VARCHAR(40) NOT NULL,
	capacity INT NOT NULL,
	aircraft_range NUMERIC(4,0) NOT NULL, 

	CHECK (capacity > 0),
	CHECK (aircraft_range > 0),

	PRIMARY KEY (aircraft_model)
);

CREATE TABLE aircraft
(
	aircraft_code VARCHAR(3), 
	aircraft_model VARCHAR(40) NOT NULL,

	CHECK (aircraft_code ~* '^\d{3}$'),

	PRIMARY KEY (aircraft_code),
	FOREIGN KEY (aircraft_model) REFERENCES model(aircraft_model)
);

CREATE TABLE airport
(
	airport_code VARCHAR(3),
	airport_name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
	timezone VARCHAR(40) NOT NULL,

	CHECK (airport_code ~* '^\w{3}$'),

	PRIMARY KEY (airport_code)
);

CREATE TABLE passenger
(
	passenger_id VARCHAR(10),
	passenger_name VARCHAR(100) NOT NULL,
	contact_data NUMERIC(10,0) NOT NULL,
	
	CHECK(contact_data::text ~* '^[0-9]{10}$'),

	PRIMARY KEY (passenger_id)
);

CREATE TABLE flight
(
	flight_id SERIAL,
	arrival_airport VARCHAR(3) NOT NULL,
	departure_airport VARCHAR(3) NOT NULL,
	departure_date DATE NOT NULL,
	aircraft_code VARCHAR(3) NOT NULL UNIQUE,
	flight_range NUMERIC(4,0) NOT NULL, 
	
	CHECK (arrival_airport != departure_airport),
	CHECK (flight_range > 0),

	FOREIGN KEY(aircraft_code) REFERENCES aircraft(aircraft_code) ON DELETE CASCADE,
	FOREIGN KEY(arrival_airport) REFERENCES airport(airport_code) ON DELETE CASCADE,
	FOREIGN KEY(departure_airport) REFERENCES airport(airport_code) ON DELETE CASCADE,
	PRIMARY KEY (flight_id)
);

CREATE TABLE actual_status
(
	actual_departure_time TIME WITH TIME ZONE,
	actual_arrival_time TIME WITH TIME ZONE,
	flight_status VARCHAR(9) NOT NULL,
	flight_id INT UNIQUE NOT NULL,

	CHECK (flight_status IN ('Scheduled', 'OnTime', 'Delayed', 'Departed', 'Arrived', 'Cancelled')),

	FOREIGN KEY (flight_id) REFERENCES flight(flight_id),
	PRIMARY KEY (flight_status)
);

CREATE TABLE duration 
(
	scheduled_departure_time TIME WITH TIME ZONE,
	scheduled_arrival_time TIME WITH TIME ZONE,
	scheduled_duration numeric(4,2) NOT NULL,
	flight_id INT UNIQUE NOT NULL,

	CHECK (scheduled_duration > 0),
	CHECK (scheduled_arrival_time > scheduled_departure_time),

	FOREIGN KEY (flight_id) REFERENCES flight(flight_id),
	PRIMARY KEY (scheduled_departure_time, scheduled_arrival_time)
);

CREATE TABLE ticket
(
	ticket_no VARCHAR(13),
	amount MONEY NOT NULL,
	fare VARCHAR(11) NOT NULL,
	book_ref VARCHAR(6) NOT NULL UNIQUE,
	flight_id INT NOT NULL UNIQUE,
	passenger_id VARCHAR(10) NOT NULL UNIQUE,

	CHECK (ticket_no ~* '^\d{13}$'),
	CHECK (fare IN ('Economy', 'Business', 'First class')),
	CHECK (book_ref ~* '([a-z]|[A-Z]|\d){6}'),
	CHECK (amount::numeric::int > 0),

	FOREIGN KEY (flight_id) REFERENCES flight(flight_id) ON DELETE CASCADE,
	FOREIGN KEY (book_ref) REFERENCES booking(book_ref) ON DELETE CASCADE,
	FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id) ON DELETE CASCADE,
	PRIMARY KEY (ticket_no)
);

CREATE TABLE boarding_pass
(
	flight_id SERIAL,
	seat_no VARCHAR(3),
	boarding_no SERIAL NOT NULL, -- Has top be <= aircraft.capacity
	ticket_no VARCHAR(13) NOT NULL UNIQUE,

	FOREIGN KEY (ticket_no) REFERENCES ticket(ticket_no) ON DELETE CASCADE,
	FOREIGN KEY (flight_id) REFERENCES flight(flight_id) ON DELETE CASCADE,
	PRIMARY KEY (flight_id, seat_no)
);

-- Sample data
COPY booking FROM 'C:\database-class\data\booking.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM booking;

COPY aircraft FROM 'C:\database-class\data\aircraft.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM aircraft;

COPY airport FROM 'C:\database-class\data\airport.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM airport;

COPY passenger FROM 'C:\database-class\data\passenger.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM passenger;

COPY flight FROM 'C:\database-class\data\flight.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM flight;

COPY ticket FROM 'C:\database-class\data\ticket.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM ticket;

COPY boarding_pass FROM 'C:\database-class\data\boarding_pass.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM boarding_pass;




