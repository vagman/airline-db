create table if not exists booking
(
	book_ref varchar(6),
	book_date date not null, -- TODO: Check the flight date!
	total_cost decimal(4,2) not null,
	ticket_no varchar(13),

	check (book_ref ~* '([a-z]|[A-Z]|\d){6}'), -- A combination of 6 digits or numbers
	check (total_cost > 0),
	primary key (book_ref)
);

create table if not exists boarding_pass
(
	flight_id varchar(40),
	seat_no varchar(3),
	boarding_no serial not null,
	passenger_name varchar(100) not null,
	ticket_no varchar(13) not null unique,
	
	primary key (flight_id, seat_no)
);

create table if not exists ticket
(
	ticket_no varchar(13),
	passenger_id varchar(40) not null unique,
	passenger_name varchar(100) not null,
	contact_data varchar(100) not null,
	amount decimal(6,2) not null,
	fare varchar(11) not null,
	book_ref varchar(6) not null unique,

	check (ticket_no ~* '^\d{13}$'), -- It has to be a 13-digit number
	check (fare in ('Economy', 'Business', 'First class')),
	check (book_ref ~* '([a-z]|[A-Z]|\d){6}'),
	check (amount > 0),
	foreign key (ticket_no) references boarding_pass(ticket_no) on delete cascade,
	foreign key (ticket_no) references booking(ticket_no) on delete cascade,
	primary key (ticket_no)
);

create table if not exists flight
(
	flight_id serial,
	arrival_airport varchar(100),
	departure_airport varchar(100),
	departure_date date,
	airplane_model varchar(40) not null,
	distance numeric(4,0) not null,
	scheduled_departure_time timestamp not null,
	scheduled_arrival_time timestamp not null,
	scheduled_duration time not null,
	actual_departure_time timestamp not null,
	actual_arrival_time timestamp not null,
	flight_status varchar(9) not null,

	check (arrival_airport != departure_airport),
	check (flight_status in ('Scheduled', 'OnTime', 'Delayed', 'Departed', 'Arrived', 'Cancelled')),
	foreign key (flight_id) references ticket(flight_id) on delete cascade,
	primary key (flight_id)
);

create table if not exists aircraft
(
	aircraft_code varchar(3),
	model varchar(40) not null,
	capacity int not null check (capacity > 0),
	aircraft_range numeric(4,0) not null check (aircraft_range > 0), 

	check (aircraft_code ~* '^\d{3}$'), -- It has to be a 3-digit number
	foreign key (aircraft_code) references flight(aircraft_code) on delete cascade,
	foreign key (aircraft_code) references boarding_pass(aircraft_code) on delete cascade,
	primary key (aircraft_code)
);

create table if not exists airport
(
	airport_code varchar(3),
	name varchar(40) not null,
	city varchar(100) not null,
	timezone timestamptz not null,

	check (airport_code ~* '^\w{3}$'), -- It has to be a 3 letters
	foreign key (airport_code) references flight(airport_code) on delete cascade,
	primary key (airport_code)
);

