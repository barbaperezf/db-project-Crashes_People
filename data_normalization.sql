
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- DATA NORMALIZATION - post cleaning
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Creating final schema
DROP SCHEMA IF EXISTS final CASCADE;
CREATE SCHEMA IF NOT EXISTS final;

-- Creating tables for final data
DROP TABLE IF EXISTS final.id;
CREATE TABLE final.id (
	person_id text PRIMARY KEY NOT NULL
);
INSERT INTO final.id
SELECT person_id
FROM cleaning.crashes_people;

DROP TABLE IF EXISTS final.person;
CREATE TABLE final.person (
	person_id text NOT NULL,
	person_type VARCHAR(20) NOT NULL,
	seat_no VARCHAR(2),
	city text,
	state text,
	zipcode text,
	sex CHAR,
	age NUMERIC,
	CONSTRAINT fk_person_id FOREIGN KEY (person_id) REFERENCES final.id(person_id)
);
INSERT INTO final.person
SELECT person_id,
	person_type,
	seat_no,
	city,
	state,
	zipcode,
	sex,
	age
FROM cleaning.crashes_people;

DROP TABLE IF EXISTS final.accident;
CREATE TABLE final.accident (
	person_id text NOT NULL,
	crash_date TIMESTAMP NOT NULL,
	driver_action text,
	driver_vision text,
	physical_condition text,
	pedpedal_action text,
	pedpedal_visibility text,
	pedpedal_location text,
	bac_result text,
	bac_result_value NUMERIC,
	cell_phone_use text,
	CONSTRAINT fk_person_id FOREIGN KEY (person_id) REFERENCES final.id(person_id)
);
INSERT INTO final.accident
SELECT person_id,
	crash_date,
	driver_action,
	driver_vision,
	physical_condition,
	pedpedal_action,
	pedpedal_visibility,
	pedpedal_location,
	bac_result,
	bac_result_value,
	cell_phone_use
FROM cleaning.crashes_people;
 
DROP TABLE IF EXISTS final.injury;
CREATE TABLE final.injury (
	person_id text NOT NULL,
	safety_equipment text,
	airbag_deployed text,
	injury_classification text,
	hospital text,
	ems_agency text,
	CONSTRAINT fk_person_id FOREIGN KEY (person_id) REFERENCES final.id(person_id)
);
INSERT INTO final.injury
SELECT person_id,
	safety_equipment,
	airbag_deployed,
	injury_classification,
	hospital,
	ems_agency
FROM cleaning.crashes_people;

DROP TABLE IF EXISTS final.ref;
CREATE TABLE final.ref (
	person_id text NOT NULL,
	crash_record_id text NOT NULL,
	vehicle_id text,
	CONSTRAINT fk_person_id FOREIGN KEY (person_id) REFERENCES final.id(person_id)
);
INSERT INTO final.ref
SELECT person_id,
	crash_record_id,
	vehicle_id
FROM cleaning.crashes_people;
