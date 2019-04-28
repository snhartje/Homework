-- Stephanie Hartje - Homework 09 SQL - 04.27.19

-- Use the Sakila Database
USE sakila;

-- 1a. Display the first and last names of all actors from the table actor

-- Show whole table to check column names
SELECT * FROM actor;
--     Select the first and last name columns from the actor table
SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

--     Select and concatenate the first and last name columns from actor and rename as "Actor Name"
SELECT CONCAT(first_name, " ", last_name) AS "Actor Name"
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
--     What is one query would you use to obtain this information?

-- Select everything in the actor table
SELECT * FROM actor
-- Where the first name column is Joe
WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:

-- Query actor table to show all results 
SELECT * FROM actor
-- Where the last name column includes a word with the letters GEN in it (at middle, beginning, or end)
WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name 
--     and first name, in that order:

-- Query the actor table
SELECT * FROM actor
-- Where the last name column includes a word with the letters LI in it (at the middle, beginning, or end)
WHERE last_name LIKE "%LI%"
-- Ask for it to be in order by last name and then first name
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
--     Afghanistan, Bangladesh, and China:

-- Display all information in country table to confirm it has the information needed
SELECT * FROM country;

-- Select the country_id and country columns
SELECT country_id, country
-- From country table
FROM country
-- where the country column equals Afghanistan, Bangladesh, or China
WHERE country IN
(
	"Afghanistan", "Bangladesh", "China"
);

-- 3a. You want to keep a description of each actor. You dont think you will be performing
--    queries on a description, so create a column in the table actor named description 
--    and use the data type BLOB (Make sure to research the type BLOB, as the difference 
--    between it and VARCHAR are significant).

-- Indicate that I want to alter an existing table
ALTER TABLE actor 
-- add a column called description
ADD description 
-- with type = BLOB
BLOB 
-- after the last_name column
AFTER last_name;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

-- Indicate that I want to alter an existing table
ALTER TABLE actor
-- remove the description column
DROP COLUMN description;
-- check that the column has been removed
SELECT * FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.

-- For the last_name column
SELECT last_name,
-- Count the names and insert a new column with the count 
COUNT(*) AS last_name_count
-- From the actor table
FROM actor
-- Group by last name
GROUP BY last_name
-- show in order from highest count to lowest count
ORDER BY COUNT(*) DESC;

-- 4b. List last names of actors and the number of actors who have that last name, 
--      but only for names that are shared by at least two actors.

-- For the last_name column
SELECT last_name,
-- Count the names and insert a new column with the count 
COUNT(*) AS last_name_count
-- From the actor table
FROM actor
-- Group by last name
GROUP BY last_name
-- only show names where the count is at least 2
HAVING COUNT(*) > 1
-- show in order from highest count to lowest count
ORDER BY COUNT(*) DESC;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as 
--     GROUCHO WILLIAMS. Write a query to fix the record.

-- Update the actor table
UPDATE actor
-- set the value in the first_name column to HARPO
SET first_name = "HARPO"
-- where first_name currently equals GROUCHO and last_name currently equals WILLIAMS
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO 
--     was the correct name after all! In a single query, if the first name of the actor 
--     is currently HARPO, change it to GROUCHO.

-- Update the actor table
UPDATE actor 
-- set the value in the first_name column to GROUCHO
SET first_name = "GROUCHO"
-- where first_name currently equals HARPO and last_name currently equals WILLIAMS
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

-- Use show create table to see the SQL command I could use to re-create the table. 
SHOW CREATE TABLE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
--     Use the tables staff and address:

-- View the two tables to determine how they can be joined
SELECT * FROM staff;
SELECT * FROM address;
-- Select everything 
SELECT *
-- from the staff table and call it s
FROM staff AS s
-- join the address table (and call it a) to the staff table
JOIN address AS a
-- join them when the address_id in the staff table matches the address_id in the address table 
ON (s.address_id = a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment

-- View the two tables to determine how they can be joined
SELECT * FROM staff;
SELECT * FROM payment;
-- Select columns to display staff names and a new column summing the amount 
SELECT first_name, last_name, SUM(amount) AS "Total Amount"
-- start with the payment table and call it p
FROM payment AS p
-- join the staff table (and call it s) to the payment table
JOIN staff AS s
-- join them when the staff_id in the payment table matches the staff_id in the staff table 
ON (p.staff_id = s.staff_id)
-- specify only payments during August 2005
WHERE payment_date LIKE "2005-08%"
-- group by staff name
GROUP BY first_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

-- View the two tables to determine how they can be joined
SELECT * FROM film_actor;
SELECT * FROM film;

-- Select columns to display staff names and a new column summing the amount 
SELECT title, COUNT(actor_id) AS NumofActors
-- start with the payment table and call it p
FROM film_actor AS fa
-- join the staff table (and call it s) to the payment table
INNER JOIN film AS f
-- join them when the staff_id in the payment table matches the staff_id in the payment table 
ON (fa.film_id = f.film_id)
-- group by staff name
GROUP BY title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

-- View tables to see if they have the required data
SELECT * FROM inventory;
SELECT * FROM film;

-- Count the number of instances in the inventory table where the film_id is equal to the film_id for Hunchback Impossible from the film table
SELECT COUNT(film_id) AS "Inventory"
FROM inventory
WHERE film_id IN
(
	SELECT film_id FROM film
	WHERE title = "Hunchback Impossible"
);

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
--     List the customers alphabetically by last name:

-- View tables to see how they can be joined
SELECT * FROM payment;
SELECT * FROM customer;

-- Select columns to display customer names and a new column summing the amount 
SELECT first_name, last_name, SUM(amount) AS "Total Amount"
-- start with the payment table and call it p
FROM payment AS p
-- join the customer table (and call it c) to the payment table
JOIN customer AS c
-- join them when the customer_id in the payment table matches the customer_id in the customer table 
ON (p.customer_id = c.customer_id)
-- group by last name (automatically puts the list in alphabetical order by last name)
GROUP BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
--     films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles 
--     of movies starting with the letters K and Q whose language is English.

-- identify tables with film names and information about language
SELECT * FROM film;
SELECT * FROM language;

-- select the titles from the file table where the title
SELECT title
FROM film
WHERE title IN
-- begins with a K or Q and the language
(
	SELECT title 
    FROM film
    WHERE title LIKE "K%" OR title LIKE "Q%" AND language_id IN
-- is English
    (
		SELECT language_id
        FROM language
        WHERE name = "English"
	)
);
 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

 -- identify tables with film names and information about actor
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;

-- select the first and last names of the actors where the actor id
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
-- is associated with a film_id that
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
-- is associated with the movie Alone Trip
    (
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
	)
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
--     of all Canadian customers. Use joins to retrieve this information.

 -- identify tables with customers, a way to identify customers from Canada, and email addresses
 SELECT * FROM customer;
 SELECT * FROM address;
 SELECT * FROM city;
 SELECT * FROM country;
 
 -- Select columns to display customer names and email 
SELECT first_name, last_name, email
-- start with the customer table and call it cust
FROM customer AS cust
-- join the address table (and call it a) to the customer table
JOIN address AS a
-- join them when the address_id in the customer table matches the address_id in the address table 
ON (cust.address_id = a.address_id)
-- join city as cty to the other tables
JOIN city as cty
-- where city_id matches in cty and a
ON (a.city_id = cty.city_id)
-- join country as ctry to the other tables
JOIN country as ctry
-- where country_id matches in cty and ctry
ON (cty.country_id = ctry.country_id)
-- show the lines where the country is Canada
WHERE country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--     Identify all movies categorized as family films.

 -- identify necessary tables
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM film;

-- select the title of movies where
SELECT title
FROM film
WHERE film_id IN
-- the film_id matches
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
-- the category id where the category is family
    (
		SELECT category_id
        FROM category
        WHERE name = "family"
	)
);

-- 7e. Display the most frequently rented movies in descending order.

-- Select tables with the necessary data
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

-- select title from film and count of the rentals from rental
SELECT f.title, COUNT(r.rental_date) AS count
FROM film AS f
-- join the inventory table (and call it i) to the film table
JOIN inventory AS i
-- join them when the film_id in the film table matches the film_id in the inventory table 
ON (f.film_id = i.film_id)
-- join the rental table 
JOIN rental as r
-- when inventory id matches
ON (i.inventory_id = r.inventory_id)
-- show results by title
GROUP BY title
-- sort from highest rental count to lowest rental count
ORDER BY count DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

-- Select tables with necessary information
SELECT * FROM store;
SELECT * FROM payment;
SELECT * FROM staff;

-- select store_id and sum of rental payments
SELECT str.store_id, SUM(p.amount) AS business
FROM store AS str
JOIN staff AS s
ON (str.store_id = s.store_id)
JOIN payment AS p
ON (s.staff_id = p.staff_id)
GROUP BY store_id;

--  7g. Write a query to display for each store its store ID, city, and country.

SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT s.store_id, cty.city, ctry.country
FROM store AS s
JOIN address AS a
ON (s.address_id = a.address_id)
JOIN city AS cty
ON (a.city_id = cty.city_id)
JOIN country AS ctry
ON (cty.country_id = ctry.country_id)
GROUP BY store_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: 
--     category, film_category, inventory, payment, and rental.)

SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM rental;
SELECT * FROM payment;


SELECT c.name, SUM(p.amount) AS "Gross Revenue"
FROM category AS c
JOIN film_category AS f
ON (c.category_id = f.category_id)
JOIN inventory AS i
ON (f.film_id = i.film_id)
JOIN rental AS r
ON (i.inventory_id = r.inventory_id)
JOIN payment AS p
ON (r.rental_id = p.rental_id)
GROUP BY name
ORDER BY SUM(p.amount) DESC;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
--     Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query
--     to create a view.

CREATE VIEW Top_5_Genres AS
	SELECT c.name, SUM(p.amount) AS "Gross Revenue"
	FROM category AS c
	JOIN film_category AS f
	ON (c.category_id = f.category_id)
	JOIN inventory AS i
	ON (f.film_id = i.film_id)
	JOIN rental AS r
	ON (i.inventory_id = r.inventory_id)
	JOIN payment AS p
	ON (r.rental_id = p.rental_id)
	GROUP BY name
	ORDER BY SUM(p.amount) DESC;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_5_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW Top_5_Genres;

