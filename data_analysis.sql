/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- DATA ANALYSIS
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- City with the most accidents
SELECT city, COUNT (*)
FROM final.person
WHERE city <> 'UNKNOWN' AND city <> 'OTHER' AND city <> 'CHICAGO'
GROUP BY city
ORDER BY COUNT(*) DESC
LIMIT 10;

--Accidentes w/ safety belt VS w/o safety belt
SELECT COUNT(*)
FROM (
	SELECT * 
	FROM final.injury
	WHERE safety_equipment = 'SAFETY BELT USED'
)
WHERE injury_classification = 'FATAL' OR injury_classification = 'INCAPACITATING INJURY'; 
--5,046

SELECT COUNT(*)
FROM (
	SELECT * 
	FROM final.injury
	WHERE safety_equipment <> 'SAFETY BELT USED'
)
WHERE injury_classification = 'FATAL' OR injury_classification = 'INCAPACITATING INJURY';
--12,490

--Men vs Women - Drugs and Alcohol
SELECT COUNT(*)
FROM (
    SELECT * 
    FROM final.person
    WHERE sex = 'M'
) AS men
INNER JOIN final.id ON men.person_id = final.id.person_id
INNER JOIN final.accident ON final.id.person_id = final.accident.person_id
WHERE final.accident.physical_condition ILIKE '%IMPAIRED%';
--6,047

SELECT COUNT(*)
FROM (
    SELECT * 
    FROM final.person
    WHERE sex = 'F'
) AS women
INNER JOIN final.id ON women.person_id = final.id.person_id
INNER JOIN final.accident ON final.id.person_id = final.accident.person_id
WHERE final.accident.physical_condition ILIKE '%IMPAIRED%';
--2,266

--The importance of an ambulance
SELECT COUNT(*)
FROM (
	SELECT * 
    FROM final.injury
    WHERE ems_agency = 'AMBULANCE' AND injury_classification = 'FATAL'
);--225
SELECT COUNT(*)
FROM (
	SELECT * 
    FROM final.injury
    WHERE ems_agency <> 'AMBULANCE' AND injury_classification = 'FATAL'
);--773
SELECT COUNT(*)
FROM (
	SELECT * 
    FROM final.injury
    WHERE ems_agency = 'AMBULANCE' AND (injury_classification = 'INCAPACITATING INJURY' OR injury_classification = 'NONINCAPACITATING INJURY')
);--20,731

--Age and cell phone use
SELECT 
    age_group,
    COUNT(CASE WHEN subquery.cell_phone_use <> 'X' THEN 1 END) AS total_count,
    COUNT(CASE WHEN subquery.cell_phone_use = 'Y' THEN 1 END) AS cellphone_use_count,
    (COUNT(CASE WHEN subquery.cell_phone_use = 'Y' THEN 1 END) * 100.0 / COUNT(CASE WHEN subquery.cell_phone_use <> 'X' THEN 1 END)) AS percentage_cellphone_use
FROM (
    SELECT 
        p.person_id,
        p.age,
        a.cell_phone_use,
        CASE
            WHEN p.age < 30 THEN 'teens_twenties'
            WHEN p.age >= 30 AND p.age < 50 THEN 'thirties_fourties'
            WHEN p.age >= 50 AND p.age < 70 THEN 'fifties_sixties'
            WHEN p.age >= 70 THEN 'old'
            ELSE 'unknown'
        END AS age_group
    FROM final.person p
    INNER JOIN final.accident a ON p.person_id = a.person_id
    WHERE p.age IS NOT NULL
) AS subquery
GROUP BY age_group
ORDER BY percentage_cellphone_use DESC;
