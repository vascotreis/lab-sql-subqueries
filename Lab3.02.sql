-- How many copies of the film Hunchback Impossible exist in the inventory system?-- 

SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";

-- List all films whose length is longer than the average of all the films.

SELECT title FROM film
WHERE length > (
SELECT AVG(length) FROM film);


-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title, category
FROM film_list
WHERE category = 'Family';

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN(
	SELECT address_id from address
	WHERE city_id IN (
		SELECT city_id from city 
		WHERE country_id IN(
			SELECT country_id FROM country
			WHERE country = 'Canada')));

-- USING JOIN

SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT*
from film_actor
join actor using (actor_id)
where actor_id like(
select actor_id
from film_actor
group by actor_id
order by count(*) desc
limit 1);




-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT
	film.film_id as "Film ID",
    film.title as "Film Title",
    COUNT(
        DISTINCT inventory.inventory_id
    ) as "Copies",
    SUM(payment.amount) as "Total Sales",
    film.replacement_cost * COUNT(
        DISTINCT inventory.inventory_id
    ) as "Replacement Value",
    SUM(payment.amount) - film.replacement_cost * COUNT(
        DISTINCT inventory.inventory_id
    ) as "Net Profit"
FROM
    payment
LEFT JOIN rental ON payment.rental_id = rental.rental_id
LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film ON inventory.film_id = film.film_id
GROUP BY
    film.film_id
ORDER BY
    SUM(payment.amount) - film.replacement_cost * COUNT(
        DISTINCT inventory.inventory_id
    )
DESC;


-- Customers who spent more than the average payments.
SELECT first_name, last_name
FROM customer
WHERE customer_id IN(
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING sum(amount) > (
SELECT (total)
FROM
(SELECT sum(amount) AS total
from payment
GROUP BY customer_id)sub1));


