-- from the terminal run:
-- psql < air_traffic.sql

DROP DATABASE IF EXISTS air_traffic;

CREATE DATABASE air_traffic;

\c air_traffic

CREATE TABLE airlines
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Create countries table
CREATE TABLE countries
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Create cities table
CREATE TABLE cities
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  country_id INTEGER REFERENCES countries(id),
  UNIQUE(name, country_id)
);

-- Create flights table
CREATE TABLE flights
(
  id SERIAL PRIMARY KEY,
  airline_id INTEGER REFERENCES airlines(id),
  departure TIMESTAMP NOT NULL,
  arrival TIMESTAMP NOT NULL,
  from_city_id INTEGER REFERENCES cities(id),
  to_city_id INTEGER REFERENCES cities(id)
);

-- Create tickets table with references
CREATE TABLE tickets
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  seat TEXT NOT NULL,
  flight_id INTEGER REFERENCES flights(id)
);

CREATE TABLE tickets
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  seat TEXT NOT NULL,
  flight_id INTEGER REFERENCES flights(id)
);

-- Insert initial data
INSERT INTO airlines (name) 
VALUES 
  ('United'),
  ('British Airways'),
  ('Delta'),
  ('TUI Fly Belgium'),
  ('Air China'),
  ('American Airlines'),
  ('Avianca Brasil');

INSERT INTO countries (name) 
VALUES 
  ('United States'),
  ('Japan'),
  ('United Kingdom'),
  ('Mexico'),
  ('France'),
  ('Morocco'),
  ('UAE'),
  ('China'),
  ('Brazil'),
  ('Chile');

-- Insert cities data
INSERT INTO cities (name, country_id) 
VALUES 
  ('Washington DC', (SELECT id FROM countries WHERE name = 'United States')),
  ('Seattle', (SELECT id FROM countries WHERE name = 'United States')),
  ('Tokyo', (SELECT id FROM countries WHERE name = 'Japan')),
  ('London', (SELECT id FROM countries WHERE name = 'United Kingdom')),
  ('Los Angeles', (SELECT id FROM countries WHERE name = 'United States')),
  ('Las Vegas', (SELECT id FROM countries WHERE name = 'United States')),
  ('Mexico City', (SELECT id FROM countries WHERE name = 'Mexico')),
  ('Paris', (SELECT id FROM countries WHERE name = 'France')),
  ('Casablanca', (SELECT id FROM countries WHERE name = 'Morocco')),
  ('Dubai', (SELECT id FROM countries WHERE name = 'UAE')),
  ('Beijing', (SELECT id FROM countries WHERE name = 'China')),
  ('New York', (SELECT id FROM countries WHERE name = 'United States')),
  ('Charlotte', (SELECT id FROM countries WHERE name = 'United States')),
  ('Cedar Rapids', (SELECT id FROM countries WHERE name = 'United States')),
  ('Chicago', (SELECT id FROM countries WHERE name = 'United States')),
  ('New Orleans', (SELECT id FROM countries WHERE name = 'United States')),
  ('Sao Paolo', (SELECT id FROM countries WHERE name = 'Brazil')),
  ('Santiago', (SELECT id FROM countries WHERE name = 'Chile'));

-- Insert flights data
INSERT INTO flights (airline_id, departure, arrival, from_city_id, to_city_id)
VALUES
  ((SELECT id FROM airlines WHERE name = 'United'),
   '2018-04-08 09:00:00', '2018-04-08 12:00:00',
   (SELECT id FROM cities WHERE name = 'Washington DC'),
   (SELECT id FROM cities WHERE name = 'Seattle')),
  ((SELECT id FROM airlines WHERE name = 'British Airways'),
   '2018-12-19 12:45:00', '2018-12-19 16:15:00',
   (SELECT id FROM cities WHERE name = 'Tokyo'),
   (SELECT id FROM cities WHERE name = 'London')),
  ((SELECT id FROM airlines WHERE name = 'Delta'),
   '2018-01-02 07:00:00', '2018-01-02 08:03:00',
   (SELECT id FROM cities WHERE name = 'Los Angeles'),
   (SELECT id FROM cities WHERE name = 'Las Vegas')),
  ((SELECT id FROM airlines WHERE name = 'Delta'),
   '2018-04-15 16:50:00', '2018-04-15 21:00:00',
   (SELECT id FROM cities WHERE name = 'Seattle'),
   (SELECT id FROM cities WHERE name = 'Mexico City')),
  ((SELECT id FROM airlines WHERE name = 'TUI Fly Belgium'),
   '2018-08-01 18:30:00', '2018-08-01 21:50:00',
   (SELECT id FROM cities WHERE name = 'Paris'),
   (SELECT id FROM cities WHERE name = 'Casablanca')),
  ((SELECT id FROM airlines WHERE name = 'Air China'),
   '2018-10-31 01:15:00', '2018-10-31 12:55:00',
   (SELECT id FROM cities WHERE name = 'Dubai'),
   (SELECT id FROM cities WHERE name = 'Beijing')),
  ((SELECT id FROM airlines WHERE name = 'United'),
   '2019-02-06 06:00:00', '2019-02-06 07:47:00',
   (SELECT id FROM cities WHERE name = 'New York'),
   (SELECT id FROM cities WHERE name = 'Charlotte')),
  ((SELECT id FROM airlines WHERE name = 'American Airlines'),
   '2018-12-22 14:42:00', '2018-12-22 15:56:00',
   (SELECT id FROM cities WHERE name = 'Cedar Rapids'),
   (SELECT id FROM cities WHERE name = 'Chicago')),
  ((SELECT id FROM airlines WHERE name = 'American Airlines'),
   '2019-02-06 16:28:00', '2019-02-06 19:18:00',
   (SELECT id FROM cities WHERE name = 'Charlotte'),
   (SELECT id FROM cities WHERE name = 'New Orleans')),
  ((SELECT id FROM airlines WHERE name = 'Avianca Brasil'),
   '2019-01-20 19:30:00', '2019-01-20 22:45:00',
   (SELECT id FROM cities WHERE name = 'Sao Paolo'),
   (SELECT id FROM cities WHERE name = 'Santiago'));

-- Insert tickets data
INSERT INTO tickets (first_name, last_name, seat, flight_id)
VALUES
  ('Jennifer', 'Finch', '33B', 1),
  ('Thadeus', 'Gathercoal', '8A', 2),
  ('Sonja', 'Pauley', '12F', 3),
  ('Jennifer', 'Finch', '20A', 4),
  ('Waneta', 'Skeleton', '23D', 5),
  ('Thadeus', 'Gathercoal', '18C', 6),
  ('Berkie', 'Wycliff', '9E', 7),
  ('Alvin', 'Leathes', '1A', 8),
  ('Berkie', 'Wycliff', '32B', 9),
  ('Cory', 'Squibbes', '10D', 10);
