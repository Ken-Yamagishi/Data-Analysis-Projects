--created 2 tables for anime and rating table
CREATE TABLE anime (
	anime_id INT PRIMARY KEY,
	name VARCHAR,
	genre VARCHAR,
	type VARCHAR,
	episodes INT,
	rating FLOAT,
	members INT
);

CREATE TABLE rating (
	user_id INT PRIMARY KEY,
	anime_id INT,
	rating FLOAT
);

--Alter table because there's UNKOWN in the csv file. (Which I can change in transforming the data)
ALTER TABLE anime
ALTER COLUMN episodes TYPE VARCHAR;

--In rating.csv file, there's a case where 1 user can have multiple
--anime rating. So, I need to alter the rating table- from primay key to composite key
ALTER TABLE rating
DROP CONSTRAINT rating_pkey;

--create new primary key
ALTER TABLE rating
ADD PRIMARY KEY (user_id, anime_id);


--select 20 rows of anime table
SELECT *
FROM anime
LIMIT 20;

--top 20 highest ratings of anime with genre of action
SELECT *
FROM anime
WHERE genre = 'Action'
ORDER BY rating DESC
LIMIT 20

--select 20 rows of rating table
SELECT *
FROM rating
LIMIT 20;

--Anime with Members greater than 100000
SELECT 
	name, 
	members
FROM anime
WHERE members > 100000
ORDER BY members DESC;

--Number of Anime per Genre
SELECT 
	genre, 
	COUNT(*) AS anime_count
FROM anime
GROUP BY genre
ORDER BY anime_count DESC; 

--Average Rating Per Genre
SELECT 
	a.genre, 
	AVG(r.rating) AS average_rating
FROM anime a
JOIN rating r
ON a.anime_id = r.anime_id
WHERE r.rating != -1 -- Exclude unrated anime
GROUP BY a.genre
ORDER BY average_rating DESC;

--Top 5 Highest Rated Anime in 'Adventure' Genre
SELECT
	a.name,
	r.rating
FROM anime a
JOIN rating r
ON a.anime_id = r.anime_id
WHERE a.genre = 'Adventure'
ORDER BY r.rating DESC
LIMIT 5;




--After importing everything from csv files we'll
--Create a query that shows the top 5 anime with the highest number of members using CTE
WITH a AS (
    SELECT 
        anime_id, 
        name, 
        members 
    FROM anime
    ORDER BY members DESC
    LIMIT 5  -- Get the top 5 anime with the highest members
)
SELECT 
    name AS top_5_anime_with_highest_members
FROM a;


--Categorizing anime based on their rating, where ratings greater than 7.5 = "Highly Rated", 7.5-5 = "Moderately Rated", <5 = "Low Rated"
--Top 30 Highly Rated Anime
SELECT
    name AS anime_title,
    CASE 
        WHEN rating >= 7.5 THEN 'Highly Rated'
        WHEN rating > 5 AND rating < 7.5 THEN 'Moderately Rated'
        WHEN rating >= 0 AND rating < 5 THEN 'Low Rated'
        ELSE 'Unrated' 
    END AS rating_category
FROM anime
LIMIT 30;	

-- Top 5 Moderately Rated Anime
WITH rating_classified AS (
    SELECT
        name AS anime_title,
        CASE 
            WHEN rating >= 7.5 THEN 'Highly Rated'
            WHEN rating > 5 AND rating < 7.5 THEN 'Moderately Rated'
            WHEN rating >= 0 AND rating < 5 THEN 'Low Rated'
            ELSE 'Unrated' 
        END AS rating_category
    FROM anime
)
SELECT *
FROM rating_classified
WHERE rating_category = 'Moderately Rated'
LIMIT 5;

SELECT
	a.name AS anime_title,
	AVG(r.rating) AS anime_average_rating
FROM anime a
JOIN rating r
ON a.anime_id = r.anime_id
WHERE r.rating != -1 -- Exclude unrated anime
	--AND a.name = 'Naruto' (or any anime name)
GROUP BY a.name
ORDER BY anime_average_rating
LIMIT 1000;


--Find the 3 most popular anime (based on the number of members) in each genre, and for each anime.
WITH genre_ranking AS (
    -- Calculate top 3 anime with the highest members per genre
    SELECT
		a.genre,
		a.name,
		a.members,
		RANK() OVER(PARTITION BY a.genre ORDER BY a.members DESC) AS rank_in_genre
	FROM anime a
),
rating_class AS(
	SELECT
		--classify name based on their average rating
		a.anime_id,
		a.name,
		CASE 
			WHEN AVG(r.rating) >= 7.5 THEN 'Highly Rated'
			WHEN AVG(r.rating) < 7.5 AND AVG(r.rating) > 5 THEN 'Moderately Rated'
			WHEN AVG(r.rating) >= 0 AND AVG(r.rating) < 5 THEN 'Low Rated'
			ELSE 'Unrated'
		END AS rating_category
	FROM anime a
	JOIN rating r
	ON a.anime_id = r.anime_id
	WHERE r.rating != -1 --To Exclude Unrated anime
	GROUP BY a.anime_id, a.name
)
SELECT
	g.genre,
	g.name,
	g.members,
	r.rating_category
FROM genre_ranking g
JOIN rating_class r
ON g.name = r.name
WHERE g.rank_in_genre <= 3 --Top 3 Anime Per Genre
ORDER BY g.genre, g.rank_in_genre;


