create table flight if not exists
(
	arrival_airport varchar(100),
	departure_airport varchar(100) check (arrival_airport != departure_airport),
	departure_date date,
	airplane_model varchar(40) not null,
	distance numeric(4,0) not null,
	scheduled_departure_time timestamp not null,
	scheduled_arrival_time timestamp not null,
	scheduled_duration time not null,
	actual_departure_time timestamp not null,
	actual_arrival_time timestamp not null,
	flight_status varchar(9) not null check (fare in ('Scheduled', 'OnTime', 'Delayed', 'Departed', 'Arrived', 'Cancelled')),

	primary key (arrival_airport, departure_airport, departure_date)
);

create table booking if not exists 
(
	book_ref varchar(6) (book_red ~* '([a-z]|[A-Z]|\d){6}'), -- A combination of 6 digits or numbers
	book_date date not null check (flight.departure_date - book_date <= 30),
	total_cost demical(4,2) not null check (amount > 0),

	foreign key (book_ref) references ticket(book_ref) on delete cascade,
	primary key (book_ref)
);

create table ticket if not exists 
(
	ticket_no varchar(13) check (ticket_no ~* '^\d{13}$'), -- It has to be a 13-digit number
	passenger_id varchar(40) not null unique,
	passenger_name varchar(100) not null,
	contact_data varchar(100) not null,
	amount decimal(6,2) not null check (amount > 0),
	fare varchar(11) not null check (fare in ('Economy', 'Business', 'First class')),
	book_ref varchar(6) (book_red ~* '([a-z]|[A-Z]|\d){6}')

	foreign key (ticket_no) references boarding_pass(ticket_no) on delete cascade,
	foreign key (ticket_no) references flight(ticket_no) on delete cascade,
	primary key (ticket_no)
);

create table boarding_pass if not exists 
(
	flight_id varchar(40) not null,
	seat_no varchar(3) not null,
	boarding_no serial not null,
	passenger_name varchar(100) not null,
	
	foreign key (flight_id, seat_no) references flight(flight_id, seat_no) on delete cascade,
	primary key (flight_id, seat_no)
);

create table aircraft if not exists 
(
	aircraft_code varchar(3) check (aircraft_code ~* '^\d{3}$'), -- It has to be a 3-digit number
	model varchar(40) not null,
	capacity int not null check (capacity > 0),
	aircraft_range numeric(4,0) not null check (aircraft_range > 0), 

	foreign key (aircraft_code) references flight(aircraft_code) on delete cascade,
	foreign key (aircraft_code) references boarding_pass(aircraft_code) on delete cascade,
	primary key (aircraft_code)
);

create table airport if not exists 
(
	airport_code varchar(3) check (airport_code ~* '^\w{3}$'), -- It has to be a 3 letters,
	name varchar(40) not null,
	city varchar(100) not null,
	timezone timestamptz not null,

	foreign key (airport_code) references flight(airport_code) on delete cascade,
	primary key (airport_code)
);