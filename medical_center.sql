-- from the terminal run:
-- psql < medical_center.sql

DROP DATABASE IF EXISTS medical_center;

CREATE DATABASE medical_center;

\c medical_center


-- Doctors table to store physician information
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    hire_date DATE
);

-- Patients table to store patient information
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

-- Diseases table to store different diseases/conditions
CREATE TABLE diseases (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Visits table to track patient visits
CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id INTEGER REFERENCES doctors(id) ON DELETE SET NULL,
    visit_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Junction table for visit diagnoses (connects visits with diseases diagnosed)
CREATE TABLE visit_diagnoses (
    visit_id INTEGER REFERENCES visits(id) ON DELETE CASCADE,
    disease_id INTEGER REFERENCES diseases(id) ON DELETE CASCADE,
    diagnosis_date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    PRIMARY KEY (visit_id, disease_id)
);
