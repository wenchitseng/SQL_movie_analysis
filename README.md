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
Select rm.title as movie_title, ROUND(SUM(rm.renting_price),2) as total_revenue
From
	(Select m.title, m.renting_price
	 From renting r left join movies m
	 on r.movie_id = m.movie_id) AS rm
Group by rm.title
Order by total_revenue DESC;
 ```

**Revenue performance in different movie categories**  
✏️ Movies in the Drama genre generate the highest revenue, while those in the Art genre generate the lowest.
```SQL
Select rm.genre as movie_title, ROUND(SUM(rm.renting_price),2) as total_revenue
From
	(Select m.genre, m.renting_price
	 From renting r left join movies m
	 on r.movie_id = m.movie_id) AS rm
Group by rm.genre
Order by total_revenue DESC;
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
	Round(AVG(r.rating),2) AS average_rating,  -- The average rating (round up to 2 decimal)
	Round(SUM(m.renting_price),2) AS revenue   -- The revenue from movie rentals (round up to 2 decimal)
FROM renting AS r
LEFT JOIN customer AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
GROUP BY c.country;       --- Examine KPIs by Country
```

** ⓶ Customer Insights**  
This part focuses on customer behaviors to help the company develop personalized marketing and effective promotional campaigns, such as loyalty programs and re-engagement promotions.
- Often rented movie
- Most Frequent and less frequent customer

** ⓷ Movie and Actor Information**  
This part aids in inventory management to ensure popular movies are readily available and leverages popular actors to boost viewership and market appeal.
- Number of times each movie is rented
- Name and average rating for each actor under male and female customers in the specific country
- Movie with a rating above average
- Actors in specific categories of movie
- Actors' background (nationality, age, gender, popularity, movies)




