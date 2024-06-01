-- Lab 3 Solutions  28 May 2024
USE sakila;
-- You need to use SQL built-in functions to gain insights relating to the duration of movies:

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.

SELECT MAX(length) AS max_duration, MIN(length) AS min_duration FROM sakila.film;

-- 1.2. Express the average movie duration in hours and minutes. Dont use decimals.

SELECT CONCAT(FLOOR(SUM(length)/COUNT(LENGTH)/60),' hour ',FLOOR(MOD(SUM(length)/COUNT(LENGTH),60)),' minutes') AS avg_duration FROM sakila.film;

-- Hint: Look for floor and round functions.

-- You need to gain insights related to rental dates:
-- 2.1 Calculate the number of days that the company has been operating.

SELECT DATEDIFF(MAX(rental_date),MIN(rental_date)) AS days_operating FROM sakila.rental;

-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.

SELECT *, MONTHNAME(rental_date) AS rental_month, WEEKDAY(rental_date) AS rental_weekday FROM sakila.rental
LIMIT 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.

SELECT *, 
CASE
WHEN WEEKDAY(rental_date) < 5 THEN 'workday'
ELSE  'weekend'
END AS day_type
FROM sakila.rental;

-- Hint: use a conditional expression.
-- You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their 
-- rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.

SELECT title,
CASE
WHEN rental_duration = NULL THEN 'Not available'
ELSE rental_duration
END AS rental_duration
FROM sakila.film
ORDER BY title ASC;

-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.

-- Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. 
-- To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, 
-- so that you can address them by their first name and use their email address to send personalized recommendations. 
-- The results should be ordered by last name in ascending order to make it easier to use the data.

SELECT CONCAT(first_name," ", last_name) AS Name, LEFT(email,3) AS Email FROM sakila.customer
ORDER BY last_name ASC;

-- Challenge 2
-- Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.

SELECT COUNT(title) FROM sakila.film;

-- 1.2 The number of films for each rating.

SELECT rating AS Rating, COUNT(title) AS No_of_titles FROM sakila.film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
-- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.

SELECT rating AS Rating, COUNT(title) AS No_of_titles FROM sakila.film
GROUP BY rating
ORDER BY No_of_titles DESC;

-- 2. Using the film table, determine: 
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.

SELECT rating AS Rating, COUNT(title) AS No_of_titles, ROUND(SUM(length)/COUNT(rating),2) AS Average_length FROM sakila.film
GROUP BY rating
ORDER BY Average_length DESC;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.

SELECT rating AS Rating, COUNT(title) AS No_of_titles, ROUND(SUM(length)/COUNT(rating),2) AS Average_length FROM sakila.film
GROUP BY rating
HAVING Average_length > 120
ORDER BY Average_length DESC;

-- Bonus: determine which last names are not repeated in the table actor.

SELECT last_name, COUNT(last_name) AS Count FROM sakila.actor
GROUP BY last_name
HAVING Count = 1;

