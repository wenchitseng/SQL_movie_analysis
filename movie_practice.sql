# How much income did each movie generate
Select rm.title as movie_title, ROUND(SUM(rm.renting_price),2) as total_revenue
From
	(Select m.title, m.renting_price
	 From renting r left join movies m
	 on r.movie_id = m.movie_id) AS rm
Group by rm.title
Order by total_revenue DESC;

# Report the number of times it was rented, for customer born in 1970s
Select m.title, count(*) as number_renting, round(avg(r.rating),2) as avg_rating
From renting as r
Left join customer as c
On c.customer_id = r.customer_id  -- Add customer information
Left join movies as m
On m.movie_id = r.movie_id

Where c.date_of_birth between '1970-01-01' and '1979-12-31'
Group by m.title
Having number_renting > 1 -- Remove movies with only one rental
Order by avg_rating DESC; -- Order with highest rating first


# Report the actor name and the average rating for each actor, separately for male and female customers.
Select a.name as actor_name, c.gender as customer_gender, round(avg(r.rating),2) as avg_rating
From renting as r
Left join actsin as ai -- Join actsin table
On ai.movie_id = r.movie_id 
Left join actor as a -- Join actor table
On a.actor_id = ai.actor_id
Left join customer as c -- Join customer table
On c.customer_id = r.customer_id

Where c.country = 'Spain'
Group by a.name, c.gender
Having avg_rating is not null  -- remove average rating that are null
Order by avg_rating desc;

# KPIs per country
SELECT 
	c.country,                      -- For each country report
	COUNT(*) AS number_renting,   -- The number of movie rentals
	Round(AVG(r.rating),2) AS average_rating,  -- The average rating
	Round(SUM(m.renting_price),2) AS revenue  -- The revenue from movie rentals
FROM renting AS r
LEFT JOIN customer AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
GROUP BY c.country;

# Often rented movie
SELECT *
FROM movies
WHERE movie_id IN  -- Select movie IDs from the inner query
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5);
    
# Frequent customers
SELECT *
FROM customers
Where customer_id in            -- Select all customers with more than 10 movie rentals
	(SELECT customer_id
	FROM renting
	GROUP BY customer_id
	Having Count(*) > 10 );

# Movies with rating above average
Select m.movie_id, m.title as movie_name, Round(AVG(r.rating),2) as avg_rating
From movies m
Left join renting r
on m.movie_id = r.movie_id
Group by m.movie_id
Having avg_rating > 
    (Select AVG(rating)
    From renting);

# Analyze consumer bajavior: Select customers with less than 5 movie rentals
Select c.customer_id, c.name, COUNT(r.renting_id) as number_renting
From renting r
Left join customer c
on c.customer_id = r.customer_id
Group by c.customer_id, c.name
Having number_renting < 5;

# Customer who gave low ratings: Report a list of customers with minimum rating smaller than 4
Select c.customer_id, c.name
From renting r
Left join customer c
on c.customer_id = r.customer_id
Group by c.customer_id, c.name
Having min(r.rating) < 4 and customer_id is not null;

# Customers with at least one rating
SELECT *
FROM customer c -- Select all customers with at least one rating
WHERE EXISTS
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);  -- 秀出 rating 不為 null 的 customer 全部資訊

# Actor in comedies-- EXISTS
SELECT a.nationality, count(*) as No_of_actor -- Report the nationality and the number of actors for each nationality
FROM actor AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
Group by a.nationality;

# Young actors not coming from USA-- UNION (should have same column)
# ex1
SELECT name, 
       nationality, 
       year_of_birth
FROM actor
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actor
WHERE year_of_birth > 1990;

# ex2
SELECT name, 
       nationality, 
       year_of_birth
FROM actor
WHERE nationality <> 'USA'
INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actor
WHERE year_of_birth > 1990;

# Group by CUBE
SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   count(*)
FROM customer
GROUP BY CUBE (gender, country)
ORDER BY country;

# ROLLUP
-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
	   COUNT(*)
FROM customer
GROUP BY ROLLUP (country, gender)
ORDER BY country, gender; -- Order the result by country and gender

# GroupingSet
SELECT 
	nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    COUNT(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation

# Customer preference for actors
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT(DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actor AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-04-01'
GROUP BY a.nationality, a.gender;






    

