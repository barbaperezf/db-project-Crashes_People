-- Creating raw schema
DROP SCHEMA IF EXISTS raw CASCADE;
CREATE SCHEMA IF NOT EXISTS raw;

-- Creating table for raw data
DROP TABLE IF EXISTS raw.crashes_people;
CREATE TABLE raw.crashes_people (
	person_id text,
	person_type text,
	crash_record_id text,
	vehicle_id text,
	crash_date TIMESTAMP,
	seat_no text,
	city text,
	state text,
	zipcode text,
	sex text,
	age NUMERIC,
	drivers_license_state text,
	drivers_license_class text,
	safety_equipment text,
	airbag_deployed text,
	ejection text,
	injury_classification text,
	hospital text,
	ems_agency text,
	ems_run_no text,
	driver_action text,
	driver_vision text,
	physical_condition text,
	pedpedal_action text,
	pedpedal_visibility text,
	pedpedal_location text,
	bac_result text,
	bac_result_value NUMERIC,
	cell_phone_use text
);

	--person_id, person_type, crash_record_id, vehicle_id, crash_date, seat_no, city, state, zipcode, sex, age, drivers_license_state, drivers_license_class, safety_equipment, airbag_deployed, ejection, injury_classification, hospital, ems_agency, ems_run_no, driver_action, driver_vision, physical_condition, pedpedal_action, pedpedal_visibility, pedpedal_location, bac_result, bac_result_value,cell_phone_use

raw_data_schema_creation.sql