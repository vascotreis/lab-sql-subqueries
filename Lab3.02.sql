-- How many copies of the film Hunchback Impossible exist in the inventory system?-- 

SELECT title, COUNT(inventory_id) as inventory_count
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible"
GROUP BY title;

-- List all films whose length is longer than the average of all the films.

SELECT title
FROM film
WHERE length > (
SELECT AVG(length)
FROM film
);


-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(SELECT actor_id
FROM film_actor
WHERE film_id =
(SELECT film_id
FROM film
WHERE title = 'Alone Trip'));

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title, category
FROM film_list
WHERE category = 'Family';

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email
FROM customer
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country.country = 'Canada';

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
SELECT film.film_id as "Film ID",
film.title as "Film Title",
COUNT(DISTINCT inventory.inventory_id) as "Copies",
SUM(payment.amount) as "Total Sales",
SUM(payment.amount) - SUM(film.replacement_cost) as "Net Profit"
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY film.film_id, film.title, film.replacement_cost
ORDER BY SUM(payment.amount) - SUM(film.replacement_cost) DESC;



-- Customers who spent more than the average payments.
SELECT first_name, last_name
FROM customer
JOIN (
SELECT customer_id, SUM(amount) AS total
FROM payment
GROUP BY customer_id
HAVING total > (
SELECT AVG(total)
FROM (
SELECT SUM(amount) AS total
FROM payment
GROUP BY customer_id
) sub
)
) sub ON customer.customer_id = sub.customer_id;

