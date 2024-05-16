SELECT COUNT(*)
FROM raw.crashes_people; --1,819,430

SELECT DISTINCT person_id
FROM raw.crashes_people; --1,819,430 --primary key, unique

SELECT DISTINCT person_type
FROM raw.crashes_people; --6

SELECT DISTINCT crash_record_id
FROM raw.crashes_people; --827,033

SELECT DISTINCT vehicle_id
FROM raw.crashes_people; --1,433,462

SELECT * FROM raw.crashes_people WHERE vehicle_id ISNULL; --NULL = no hay coche involucrado

SELECT DISTINCT crash_date
FROM raw.crashes_people; --543,525

SELECT DISTINCT seat_no
FROM raw.crashes_people; --12

SELECT * FROM raw.crashes_people WHERE seat_no ISNULL; --NULL = no car was involved, tho there are some drivers with seat_no IS NULL

SELECT DISTINCT city
FROM raw.crashes_people; --13,452
SELECT DISTINCT state
FROM raw.crashes_people; --53, 52 states + null

SELECT DISTINCT zipcode
FROM raw.crashes_people; --14,432

SELECT DISTINCT sex
FROM raw.crashes_people; --4
SELECT *
FROM raw.crashes_people
WHERE sex is null;

SELECT DISTINCT age
FROM raw.crashes_people; --118, there are negative ages
SELECT *
FROM raw.crashes_people
WHERE age < 0;

SELECT DISTINCT drivers_license_state
FROM raw.crashes_people; --212

SELECT DISTINCT drivers_license_class
FROM raw.crashes_people; --283

SELECT DISTINCT safety_equipment
FROM raw.crashes_people; --20

SELECT DISTINCT airbag_deployed
FROM raw.crashes_people; --8

SELECT DISTINCT ejection
FROM raw.crashes_people; --6

SELECT DISTINCT injury_classification
FROM raw.crashes_people; --6

SELECT DISTINCT hospital
FROM raw.crashes_people; --7,356

SELECT DISTINCT ems_agency
FROM raw.crashes_people; --8,105

SELECT DISTINCT ems_run_no
FROM raw.crashes_people; --1,424

SELECT DISTINCT driver_action
FROM raw.crashes_people; --21

SELECT DISTINCT driver_vision
FROM raw.crashes_people; --15

SELECT DISTINCT physical_condition
FROM raw.crashes_people; --13

SELECT DISTINCT pedpedal_action
FROM raw.crashes_people; --24

SELECT DISTINCT pedpedal_visibility
FROM raw.crashes_people; --5

SELECT DISTINCT bac_result
FROM raw.crashes_people; --5

SELECT DISTINCT bac_result_value
FROM raw.crashes_people; --57

SELECT DISTINCT cell_phone_use
FROM raw.crashes_people; --3

