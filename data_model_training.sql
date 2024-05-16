/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- CREATION OF ATRIBUTES FOR MODEL TRAINING
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- 1. Age Groups
ALTER TABLE final.person ADD COLUMN age_group VARCHAR(20);

UPDATE final.person
SET age_group = CASE
    WHEN age < 30 THEN 'TEENS_TWENTIES'
    WHEN age >= 30 AND age < 50 THEN 'THIRTIES_FOURTIES'
    WHEN age >= 50 AND age < 70 THEN 'FIFTIES_SIXTIES'
    WHEN age >= 70 THEN 'OLD'
    ELSE 'UNKNOWN'
END;

--2. Season
ALTER TABLE final.accident ADD COLUMN season VARCHAR(20);

UPDATE final.accident
SET season = CASE
    WHEN EXTRACT(MONTH FROM crash_date) IN (12, 1, 2) THEN 'WINTER'
    WHEN EXTRACT(MONTH FROM crash_date) IN (3, 4, 5) THEN 'SPRING'
    WHEN EXTRACT(MONTH FROM crash_date) IN (6, 7, 8) THEN 'SUMMER'
    WHEN EXTRACT(MONTH FROM crash_date) IN (9, 10, 11) THEN 'FALL'
END;

--3. Injury Severity
ALTER TABLE final.injury ADD COLUMN injury_severity INT;

UPDATE final.injury
SET injury_severity = CASE
    WHEN injury_classification = 'FATAL' THEN 4
    WHEN injury_classification = 'INCAPACITATING INJURY' THEN 3
    WHEN injury_classification = 'NONINCAPACITATING INJURY' THEN 2
    WHEN injury_classification = 'REPORTED, NOT EVIDENT' THEN 1
    WHEN injury_classification = 'NO INDICATION OF INJURY' THEN 0
    ELSE NULL
END;

--4. Number of Vehicles in Accident
ALTER TABLE final.ref ADD COLUMN vehicle_count INT;

UPDATE final.ref
SET vehicle_count = subquery.vehicle_count
FROM (
    SELECT crash_record_id, COUNT(vehicle_id) AS vehicle_count
    FROM final.ref
    GROUP BY crash_record_id
) AS subquery
WHERE final.ref.crash_record_id = subquery.crash_record_id;

--5. Recency of Accident
ALTER TABLE final.accident ADD COLUMN days_since_accident INT;

UPDATE final.accident
SET days_since_accident = (CURRENT_DATE - crash_date)::INT;

--6. Probability of Hospitalization
CREATE TABLE final.hospitalization_probability (
    injury_classification VARCHAR(50),
    probability NUMERIC
);

INSERT INTO final.hospitalization_probability (injury_classification, probability)
SELECT 
    injury_classification,
    COUNT(CASE WHEN hospital IS NOT NULL THEN 1 END) / COUNT(*) AS probability
FROM final.injury
GROUP BY injury_classification;

ALTER TABLE final.person ADD COLUMN probability_of_hospitalization NUMERIC;

UPDATE final.person
SET probability_of_hospitalization = final.hospitalization_probability.probability
FROM final.injury
JOIN final.hospitalization_probability
ON final.injury.injury_classification = final.hospitalization_probability.injury_classification
WHERE final.person.person_id = final.injury.person_id;
