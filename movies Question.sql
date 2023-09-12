-- Q1 Find the total number of movies in this data set

SELECT Count(*)
FROM movies;

-- Q2 Find the total number of movies released in each year

SELECT year(release_date) AS release_year, count(*) AS Movies_released
FROM movies
GROUP BY release_year
order by release_year DESC;

-- Q3 find the total number of movies with names starting with 'The'

SELECT DISTINCT count(*)
FROM movies
WHERE title LIKE 'The%';

-- Q4 Find the top 5 movies in terms of popularity in 2019

SELECT title, popularity, release_date
FROM movies
WHERE year(release_date) = 2019
GROUP BY title, popularity, release_date
ORDER BY popularity DESC
LIMIT 5; 

-- Q5 separate genre ids into 4 different columns

SELECT genre_ids,
    CASE WHEN LENGTH(genre_ids) > 1 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(genre_ids, ',', 1), ' ', -1) END AS column1,
    CASE WHEN LENGTH(genre_ids) > 4 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(genre_ids, ',', 2), ',', -1) END AS column2,
    CASE WHEN LENGTH(genre_ids) > 8 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(genre_ids, ',', 3), ',', -1) END AS column3,
    CASE WHEN LENGTH(genre_ids) > 13 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(genre_ids, ',', -1), ' ', 1) END AS column4
FROM movies;

--  Askari edit

SELECT SUBSTRING_INDEX(genre, ',' , 1 ),
		SUBSTRING_INDEX(genre, ',' , 2),
        SUBSTRING_INDEX(genre, ',' , 3),
        SUBSTRING_INDEX(genre, ',' , 4)
FROM 
	(SELECT replace (genre_ids, ' ', '') AS genre
	FROM movies) AS subquery;


-- Q6 find the top rated movie in each year

SELECT max(vote_average) AS Top_rated_movie, year(release_date) AS release_year
FROM movies
group by release_year
order by release_year DESC; 

-- Q7 find the total votes made in each year

SELECT SUM(vote_count) AS total_vote_count, year(release_date) AS release_year
FROM movies
group by release_year
order by release_year DESC;

-- Q8 find the number of movies released in each month of 2015

SELECT count(*) AS total_movies_per_month, month(release_date) AS release_month, year(release_date) As release_year
FROM movies
GROUP BY release_month, release_year
ORDER BY release_year;

-- Q9 find the average yearly turn over of votes in each year

SELECT round(avg(vote_count), 2 ) AS AVG_Votes_Yearly, year(release_date) AS release_year
FROM movies
group by release_year
order by release_year DESC;

-- Q10 generate just one column that consists of all unique genre ids

SELECT 
    DISTINCT_GENRES.genre
FROM (
    SELECT GROUP_CONCAT(DISTINCT genre_ids SEPARATOR ', ') AS combined_genres
    FROM movies
) AS movies_genre_ids
CROSS JOIN (
    SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genre_ids, ',', n.n), ',', -1)) AS genre
    FROM movies
    CROSS JOIN (
        SELECT 1 AS n UNION ALL
        SELECT 2 UNION ALL
        SELECT 3 UNION ALL
        SELECT 4
    ) n
    WHERE LENGTH(genre_ids) - LENGTH(REPLACE(genre_ids, ',', '')) >= n.n - 1
) AS DISTINCT_GENRES;


-- Q11 find the total number of movies belonging to each genre

SELECT 
    count(*) AS Total_MoviesByEachGenre, DISTINCT_GENRES.genre
FROM (
    SELECT GROUP_CONCAT(DISTINCT genre_ids SEPARATOR ', ') AS combined_genres
    FROM movies
) AS movies_genre_ids
CROSS JOIN (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genre_ids, ',', n.n), ',', -1)) AS genre
    FROM movies
    CROSS JOIN (
        SELECT 1 AS n UNION ALL
        SELECT 2 UNION ALL
        SELECT 3 UNION ALL
        SELECT 4
    ) n
    WHERE LENGTH(genre_ids) - LENGTH(REPLACE(genre_ids, ',', '')) >= n.n - 1
) AS DISTINCT_GENRES
GROUP BY DISTINCT_GENRES.genre;

-- Q12 rank movies in descending order of vote count for each year  

SELECT *
FROM(
	SELECT year(release_date) as release_year, title, movie_id, popularity, dense_rank() OVER (partition by year(release_date) order by popularity DESC) AS ranking
	FROM movies
	GROUP BY release_year, title, movie_id, popularity)
    AS subquery
WHERE ranking <=5
ORDER BY release_year DESC;






