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
	aircraft_model VARCHAR(40),
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
	contact_data VARCHAR(15) NOT NULL,

	CHECK(contact_data::text ~* '^[0-9]{10}$'),

	PRIMARY KEY (passenger_id)
);

CREATE TABLE flight
(
	flight_id SERIAL,
	arrival_airport VARCHAR(3) NOT NULL,
	departure_airport VARCHAR(3) NOT NULL,
	departure_date DATE NOT NULL,
	aircraft_code VARCHAR(3) NOT NULL,
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
	flight_id INT,
	flight_status VARCHAR(9) NOT NULL,
	actual_departure_time TIMESTAMPTZ,
	actual_arrival_time TIMESTAMPTZ,

	CHECK (flight_status IN ('Scheduled', 'OnTime', 'Delayed', 'Departed', 'Arrived', 'Cancelled')),

	FOREIGN KEY (flight_id) REFERENCES flight(flight_id),
	PRIMARY KEY (flight_id, flight_status)
);

CREATE TABLE duration 
(
	flight_id INT UNIQUE NOT NULL,
	scheduled_departure_time TIMESTAMPTZ,
	scheduled_arrival_time TIMESTAMPTZ,
	scheduled_duration VARCHAR(20),

	CHECK (scheduled_arrival_time > scheduled_departure_time),

	FOREIGN KEY (flight_id) REFERENCES flight(flight_id),
	PRIMARY KEY (scheduled_departure_time, scheduled_arrival_time)
);

CREATE TABLE ticket
(
	ticket_no VARCHAR(13),
	amount MONEY NOT NULL,
	fare VARCHAR(11) NOT NULL,
	book_ref VARCHAR(6) NOT NULL,
	flight_id INT NOT NULL, 
	passenger_id VARCHAR(10) NOT NULL,

	CHECK (fare IN ('Economy', 'Business', 'First class')),
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
	boarding_no SERIAL NOT NULL,
	ticket_no VARCHAR(13) NOT NULL UNIQUE,

	FOREIGN KEY (ticket_no) REFERENCES ticket(ticket_no) ON DELETE CASCADE,
	FOREIGN KEY (flight_id) REFERENCES flight(flight_id) ON DELETE CASCADE,
	PRIMARY KEY (flight_id, seat_no)
);

-- Sample data
COPY booking FROM 'C:\database-class\data\booking.csv' DELIMITER ',' CSV HEADER;
COPY model FROM 'C:\database-class\data\model.csv' DELIMITER ',' CSV HEADER;
COPY aircraft FROM 'C:\database-class\data\aircraft.csv' DELIMITER ',' CSV HEADER;
COPY airport FROM 'C:\database-class\data\airport.csv' DELIMITER ',' CSV HEADER;
COPY passenger FROM 'C:\database-class\data\passenger.csv' DELIMITER ',' CSV HEADER;
COPY flight FROM 'C:\database-class\data\flight.csv' DELIMITER ',' CSV HEADER;
COPY actual_status FROM 'C:\database-class\data\actual_status.csv' DELIMITER ',' CSV HEADER;
COPY duration FROM 'C:\database-class\data\duration.csv' DELIMITER ',' CSV HEADER;
COPY ticket FROM 'C:\database-class\data\ticket.csv' DELIMITER ',' CSV HEADER;
COPY boarding_pass FROM 'C:\database-class\data\boarding_pass.csv' DELIMITER ',' CSV HEADER;
