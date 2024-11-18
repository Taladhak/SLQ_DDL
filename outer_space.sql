-- from the terminal run:
-- psql < outer_space.sql

DROP DATABASE IF EXISTS outer_space;

CREATE DATABASE outer_space;

\c outer_space

CREATE TABLE galaxies
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE stars
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  galaxy_id INTEGER REFERENCES galaxies(id)
);

CREATE TABLE planets
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  orbital_period_in_years FLOAT NOT NULL,
  star_id INTEGER REFERENCES stars(id),
  moons TEXT[]
);

-- Insert galaxies
INSERT INTO galaxies (name) VALUES ('Milky Way');

-- Insert stars
INSERT INTO stars (name, galaxy_id) 
VALUES 
  ('The Sun', 1),
  ('Proxima Centauri', 1),
  ('Gliese 876', 1);

-- Insert planets
INSERT INTO planets (name, orbital_period_in_years, star_id, moons)
VALUES
  ('Earth', 1.00, 1, '{"The Moon"}'),
  ('Mars', 1.88, 1, '{"Phobos", "Deimos"}'),
  ('Venus', 0.62, 1, '{}'),
  ('Neptune', 164.8, 1, '{"Naiad", "Thalassa", "Despina", "Galatea", "Larissa", "S/2004 N 1", "Proteus", "Triton", "Nereid", "Halimede", "Sao", "Laomedeia", "Psamathe", "Neso"}'),
  ('Proxima Centauri b', 0.03, 2, '{}'),
  ('Gliese 876 b', 0.23, 3, '{}');

