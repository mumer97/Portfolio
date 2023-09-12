select *
from movies;

ALTER TABLE movies
CHANGE COLUMN ï»¿id movie_id VARCHAR(20) NULL;

SET sql_safe_updates = 0;

UPDATE movies
SET release_date = CASE
	WHEN release_date LIKE '%/%' THEN date_format(str_to_date(release_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN release_date LIKE '%-%' THEN date_format(str_to_date(release_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

DESCRIBE movies;

ALTER Table movies
modify column release_date DATE;
