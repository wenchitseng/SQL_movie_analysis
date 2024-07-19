# 🎬  Data-Driven Analysis in SQL
It is a case study using SQL queries (JOIN, GROUP BY, Esist, OLAP) to analyze **a movie rental company called MovieNow** with a customer information database, movie ratings, background information on actors, and more.
## 🔍 Dataset
- Movie
<img width="500" alt="image" src="https://github.com/user-attachments/assets/c464866b-a023-4a59-937b-8bad3a738ca2">

  
- Customer of the online movie rental company
<img width="500" alt="image" src="https://github.com/user-attachments/assets/38679a5e-c475-4e70-af7d-334697eb4e6c">

  
- Renting Record
<img width="450" alt="image" src="https://github.com/user-attachments/assets/8c21dc57-f128-47b7-a981-2e1f1e302307">

  
- Actor
<img width="430" alt="image" src="https://github.com/user-attachments/assets/3ad30b8a-4954-4802-b89f-36e282963a63">

  
- Actsin
<img width="200" alt="image" src="https://github.com/user-attachments/assets/c11e158e-73cd-4ae0-9469-5c67a13f73a4">


## 👩🏻‍💻 SQL queries
I employ simple SQL queries to extract and aggregate data from the relational database and use more complex queries with **GROUP BY, LEFT JOIN, and sub-queries** to gain insights into customer preferences. Then, I use nested and correlated nested queries, utilizing functions like **EXISTS and UNION** to categorize customers, movies, actors, and more. Finally, I apply **OLAP extensions in SQL, such as CUBE, ROLLUP, and GROUPING SETS** operators, to aggregate data on multiple levels for deeper analysis.


## 💡 Highlight Findings
### ⓵ Revenue & Performance Metrics
This part aims to help prioritize marketing strategies and resource allocations by focusing on high-performing movie categories in terms of revenue, ratings, and rental performance.  

**Income each movie generates**  
✏️ 'Bridget Jones- The Edge of Reason' is the top-seller in the rental company.
```SQL
SELECT rm.title as movie_title, ROUND(SUM(rm.renting_price),2) AS total_revenue
FROM
	(SELECT m.title, m.renting_price
	 FROM renting r LEFT JOIN movies m
	 ON r.movie_id = m.movie_id) AS rm
GROUP BY rm.title
ORDER BY total_revenue DESC;
 ```

**Revenue performance in different movie categories**  
✏️ Movies in the Drama genre generate the highest revenue, while those in the Art genre generate the lowest.
```SQL
SELECT rm.genre, AS movie_title, ROUND(SUM(rm.renting_price),2) AS total_revenue
FROM
	(SELECT m.genre, m.renting_price
	 FROM renting r LEFT JOIN movies m
	 ON r.movie_id = m.movie_id) AS rm
GROUP BY rm.genre
ORDER BY total_revenue DESC;
```

**Often rented movie**  
✏️ The top five frequently rented movies are in the Drama and Comedy genres, reflecting customer preferences and trends. Among them, 'One Night at McCool's' (Comedy), 'Swordfish' (Drama), and 'What Women Want' (Comedy) are the top three. The company should ensure these three movies are always in stock to meet customer demand.
```SQL
SELECT *
FROM movies
WHERE movie_id IN     -- Select movie IDs from the inner query
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5);
```

**KPIs per country**  
✏️ The KPIs provide the company with an overview of rental performance and customer engagement in different countries, allowing for adjustments in marketing strategies.
  - Customer engagement: Number of active customers measured by the number of rentals.
  - Customer satisfaction: This could be quantified by the average rating of all movies.
  - Revenue: Revenue is a trivial indicator of success, for MovieNow this is calculated as the sum of the price for rented movies.
```SQL
SELECT 
	c.country,                                 -- For each country report
	COUNT(*) AS number_renting,                -- The number of movie rentals
	ROUND(AVG(r.rating),2) AS average_rating,  -- The average rating (round up to 2 decimal)
	ROUND(SUM(m.renting_price),2) AS revenue   -- The revenue from movie rentals (round up to 2 decimal)
FROM renting AS r
LEFT JOIN customer AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
GROUP BY c.country;       --- Examine KPIs by Country
```

 ### ⓶ Customer Insights 
This part focuses on customer behaviors to help the company develop personalized marketing and effective promotional campaigns, such as loyalty programs and re-engagement promotions.  
**Average rating per customer**  
✏️ From the results, the company can see how many times each customer has rented movies and how engaged they are in giving ratings and making purchases. By examining these results, the owner can develop marketing strategies to enhance the customer experience, such as loyalty programs or promotional campaigns, to encourage customer retention and involvement.
```SQL
SELECT customer_id,
       ROUND(AVG(rating),2) as average_rating,
       COUNT(rating) as times_of_rating,
       COUNT(*) as time_of_renting
FROM renting
GROUP BY customer_id
ORDER BY AVG(rating) DESC;
```

**Most Frequent and less frequent customers**  
```SQL
SELECT *
FROM customer
WHERE customer_id IN            -- Select all customers with more than 10 movie rentals
	(SELECT customer_id
	 FROM renting
	 GROUP BY customer_id
	 Having Count(*) > 10 );
```
```SQL
SELECT *
FROM customer
WHERE customer_id IN (         -- Select all customers with less than 3 movie rentals
    SELECT customer_id
    FROM renting
    GROUP BY customer_id
    HAVING COUNT(*) < 3
);
```

⓷ Movie and Actor Information**  
This part aids in inventory management to ensure popular movies are readily available and leverages popular actors to boost viewership and market appeal.
- Number of times each movie is rented
- Name and the average rating for each actor under male and female customers in the specific country
- Movie with a rating above average
- Actors in specific categories of movie
- Actors' background (nationality, age, gender, popularity, movies)




