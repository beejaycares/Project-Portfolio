-- Active: 1718910486957@@127.0.0.1@3306@data_science

SELECT * FROM ds_salaries;

drop view IF EXISTS ds_scientists;
CREATE VIEW ds_scientists AS SELECT * FROM ds_salaries;

select * from ds_scientists;

/* lets rename the abbreviation in the experience level*/
UPDATE ds_scientists
SET experience_level = CASE
WHEN experience_level = 'SE' THEN 'Senior-Level/Expert'
WHEN experience_level = 'EN' THEN 'Entry-Level/Junior'
WHEN experience_level = 'EX' THEN 'Executive-level/Director'
ELSE experience_level = 'Mid-Level/Intermediate'
END;

UPDATE ds_scientists
SET experience_level = CASE 
    WHEN  experience_level = '0' THEN 'Mid-Level/Intermediate'
    ELSE  experience_level
END;


/* lets rename the abbreviation in the employment_type*/
UPDATE ds_scientists
SET employment_type = CASE
WHEN employment_type = 'FT' THEN 'Full-time'
WHEN employment_type = 'PT' THEN 'Part-time'
WHEN employment_type = 'FL' THEN 'Freelance'
WHEN employment_type = 'CO' THEN 'Contract'
ELSE employment_type
END;

UPDATE ds_scientists
SET employment_type = CASE
WHEN employment_type = 'CT' THEN 'Contract'
ELSE employment_type
END;


SELECT employee_residence, SUM(salary_in_usd) FROM ds_scientists
GROUP BY employee_residence
ORDER BY SUM(salary_in_usd) DESC;


CREATE VIEW countrycodes AS 
SELECT iso2, country FROM countries_iso3166b;

SELECT * FROM countrycodes;
/* lets rename the abbreviation in the  employee_residence*/
UPDATE ds_scientists d
JOIN countrycodes c ON d.employee_residence = c.iso2
SET d.employee_residence = c.country;


SELECT * FROM ds_scientists;


/* There are few of the country names imported with unwanted characters. Lets fix that */

SELECT * FROM ds_scientists WHERE employee_residence LIKE 'United States%';

UPDATE ds_scientists
SET employee_residence = CASE 
WHEN employee_residence LIKE 'United States%' THEN 'United States of America'
ELSE employee_residence
END;

SELECT company_location, AVG(salary_in_usd) FROM ds_scientists
GROUP BY company_location;

SELECT * FROM ds_scientists
WHERE company_location = 'AE';

UPDATE ds_scientists
SET employee_residence = CASE 
WHEN company_location = 'AE' THEN 'United Arab Emirates'
ELSE employee_residence
END;


SELECT * FROM ds_scientists
WHERE employee_residence LIKE '%Arab%';

SELECT company_size, AVG(salary ) FROM ds_scientists
GROUP BY company_size;

/* lets rename the abbreviation in the company_size*/
UPDATE ds_scientists
SET company_size = CASE 
WHEN company_size = 'L' THEN 'Large'
WHEN company_size = 'M' THEN 'Medium'
WHEN company_size = 'S' THEN 'Small'
END;

SELECT * FROM ds_scientists;
