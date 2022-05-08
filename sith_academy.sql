-- kill other connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'sith_academy' AND pid <> pg_backend_pid();
-- (re)create the database
DROP DATABASE IF EXISTS sith_academy;
CREATE DATABASE sith_academy;

-- connect via psql
\c sith_academy

-- database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;

---
--- CREATE tables
---
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    home_world TEXT,
    sith_name TEXT NOT NULL,
    account_id INT,
    course_id INT
);


CREATE TABLE instructors (
    instructor_id SERIAL PRIMARY KEY,
    sith_name TEXT NOT NULL,
    home_world TEXT,
    account_id INT,
    course_id INT
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name TEXT NOT NULL,
    instructor_id INT,
    student_id INT
);

--
-- Adding user account to students and instructors
--
ALTER TABLE instructors
ADD CONSTRAINT fk_instructors_accounts
FOREIGN KEY (account_id)
REFERENCES accounts (account_id);

ALTER TABLE students
ADD CONSTRAINT fk_students_accounts
FOREIGN KEY (account_id)
REFERENCES accounts (account_id);

--
-- Adding students and instructors to courses
--

ALTER TABLE instructors
ADD CONSTRAINT fk_instructors_courses
FOREIGN KEY (course_id)
REFERENCES courses (course_id);

ALTER TABLE students
ADD CONSTRAINT fk_students_courses
FOREIGN KEY (course_id)
REFERENCES courses (course_id);


--
-- Inserts
--

INSERT INTO instructors (sith_name, home_world)
VALUES 
('Darth JarJar', 'Naboo'),
('Darth Bane', 'Moraband'),
('Revan', 'Mandolorian');

INSERT INTO students (first_name, last_name, home_world, sith_name)
VALUES
('Lee', 'Otts', 'Earth', 'Ummmm'),
('Grogu', 'Just Grogu', 'Unknown', 'Baby Yoda'),
('Rebecca', 'Otts', 'Earth', 'Awesomesauce');

INSERT INTO courses (course_name)
VALUES
('Sith History'),
('Famous Siths'),
('Lightsaber Combat');

-- Run this after edits. Deletes database. Remove top portiion prior to completion  
-- cat sith_academy.sql | docker exec -i pg_container psql

-- ALTER TABLE
-- ADD CONSTRAINT
-- FOREIGN KEY
-- REFERENCES