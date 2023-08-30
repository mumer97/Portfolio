USE portfolioproject;

-- QUESTION 

-- WHAT IS THE GENDER BREAKDOWN OF THE EMPLOYEES WORKING IN THE COMPANY?
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age>=18 AND termdate =''
GROUP BY gender;

-- WHAT IS THE RACE/ETHNICITY BREAKDOWN OF THE EMPLOYEES WORKING IN THE COMPANY?

SELECT race, COUNT(*) AS count
FROM hr
WHERE age>=18 AND termdate = ''
GROUP BY Race
ORDER BY count(*) DESC;

-- WHAT IS THE AGE DISTRIBUTION OF THE EMPLOYEES WORKING IN THE COMPANY?

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM HR
WHERE age>=18 AND termdate = '';

SELECT 
	CASE
		WHEN age>=18 AND age<=24 THEN '18-24'
        WHEN age>=25 AND age<=34 THEN '25-34'
        WHEN age>=35 AND age<=44 THEN '35-44'
        WHEN age>=45 AND age<=54 THEN '45-54'
        WHEN age>=55 AND age<=64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) AS count
FROM hr
WHERE age>=18 AND termdate = ''
GROUP BY age_group
ORDER BY age_group;
    
SELECT 
	CASE
		WHEN age>=18 AND age<=24 THEN '18-24'
        WHEN age>=25 AND age<=34 THEN '25-34'
        WHEN age>=35 AND age<=44 THEN '35-44'
        WHEN age>=45 AND age<=54 THEN '45-54'
        WHEN age>=55 AND age<=64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    count(*) AS count
FROM hr
WHERE age>=18 AND termdate = ''
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- HOW MANY EMPLOYEES WORK IN HEADQUATERS VS REMOTE LOCATION AT THE COMPANY?

SELECT location, gender, count(*) AS count
FROM hr
WHERE age>=18 AND termdate = ''
GROUP BY location, gender
ORDER BY location;

-- WHAT IS THE AVERAGE LENGTH OF EMPLOYMENT FOR EMPLOYEES THAT HAVE BEEN TERMINATED?

SELECT 
	round(avg(datediff(termdate, hire_date))/365,2) AS AVG_LENGTH_EMPLOYMENT
FROM hr
WHERE age>=18 AND termdate<= curdate() AND termdate!= ''; 

-- HOW DOES GENDER DISTRIBUTION VARY ACROSS DEPARTMENTS AND JOB TITLES?

SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age>=18 AND termdate = ''
GROUP BY department, gender
ORDER BY department;

-- WHAT IS THE DISTRIBUTION OF JOB TITLES ACROSS THE COMPANY?

SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age>=18 AND termdate = ''
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- WHAT DEPARTMENT HAS THE HIGHEST TURNOVER RATE?

SELECT department, total_count, terminated_count, terminated_count/total_count AS termination_rate
FROM (
	SELECT department, count(*) AS total_count,
    SUM(CASE WHEN termdate !='' AND termdate<= curdate() THEN 1 ELSE 0 END) AS terminated_count
	FROM hr
	WHERE age>=18
	GROUP BY department) AS subquery
ORDER BY termination_rate DESC;

-- WHAT IS THE DISTRIBUTION OF EMPLOYEES ACROSS LOCATIONS BY CITY AND STATE?

SELECT location_city, location_state, count(*) AS count
FROM hr
WHERE age>=18 AND termdate = ''
GROUP BY location_city, location_state
ORDER BY location_city;

-- HOW HAS THE COMPANY'S EMPLOYEE COUNT CHANGED OVER TIME BASED ON HIRE AND TERM DATES?

SELECT year, 
hires, 
terminations, 
hires-terminations AS total_employees, 
round((hires-terminations)/hires*100, 2) AS rentention_rate
FROM (
	SELECT YEAR(hire_date) AS year, 
    count(*) AS hires,
    SUM(CASE WHEN termdate !='' AND termdate<= curdate() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age>=18
    GROUP BY YEAR(hire_date)
    ) AS subquery
ORDER BY year ASC;

-- WHAT IS THE TENURE DISTRIBUTION FOR EACH DEPARTMENT?

SELECT department, round(avg(datediff(termdate, hire_date)/365),1) AS tenure
FROM hr
WHERE termdate !='' AND termdate<= curdate() AND age>=18
GROUP BY department;
	 
