#1a. Display the first and last names of all actors from the table actor
SELECT first_name,last_name
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name ,' ',last_name)) AS 'Actor Name'
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id,first_name,last_name
FROM actor
WHERE first_name = 'Joe';

#2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id,first_name,last_name
FROM actor
WHERE last_name LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT actor_id,first_name,last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY first_name,last_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id,country 
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor 
ADD COLUMN middle_name VARCHAR(45) AFTER first_name;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor 
MODIFY COLUMN middle_name BLOB;

#3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,count(last_name) AS count
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,count(last_name) AS count
FROM actor
GROUP BY last_name
HAVING count(last_name)>=2;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
set first_name='HARPO'
WHERE first_name='GROUCHO' and last_name='WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
UPDATE actor
SET first_name= CASE
					WHEN first_name='HARPO' THEN 'GROUCHO'
					ELSE 'MUCHO GROUCHO'
				END

WHERE actor_id=172; #actor_id is 172 for the record HARPO WILLIAMS

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;


#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT S.first_name,S.last_name,A.address,A.address2,C.city,CTR.country
FROM staff S
LEFT JOIN address A ON S.address_id=A.address_id
LEFT JOIN city C ON A.city_id=C.city_id
LEFT JOIN country CTR ON C.country_id=CTR.country_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT S.first_name,S.last_name,SUM(P.amount) as 'total_amount'
FROM staff S
LEFT JOIN payment P ON S.staff_id=P.staff_id
GROUP BY S.first_name,S.last_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT F.title,COUNT(FA.actor_id) AS 'actor_count'
FROM film F
INNER JOIN film_actor FA ON F.film_id=FA.film_id
GROUP BY F.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system
SELECT COUNT(I.film_id) AS 'available_copies'
FROM film F
INNER JOIN inventory I ON F.film_id=I.film_id
WHERE F.title='Hunchback Impossible';


#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT C.first_name,C.last_name,SUM(P.amount) AS 'total_paid'
FROM customer C
LEFT JOIN payment P ON C.customer_id=P.customer_id
GROUP BY C.first_name,C.last_name
ORDER BY C.last_name;


#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title,language_id
FROM film
WHERE (title LIKE 'Q%' OR title LIKE 'K%') AND language_id IN (SELECT language_id
															 FROM language 
															 WHERE name = 'English');
                                                             
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * 
FROM actor
WHERE actor_id IN (
					SELECT actor_id
					FROM film_actor
					WHERE film_id IN ( 
										SELECT film_id
                                        FROM film
                                        WHERE title = 'Alone Trip'
									)
					);

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT C.first_name,C.last_name,C.email
FROM customer C
INNER JOIN address A ON C.address_id=A.address_id
INNER JOIN city CT ON CT.city_id=A.city_id
INNER JOIN country CTR ON CTR.country_id=CT.country_id
WHERE CTR.country='Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT F.title,C.name
FROM film F
INNER JOIN film_category FC ON F.film_id=FC.film_id
INNER JOIN category C ON FC.category_id=C.category_id
WHERE C.name = 'Family';

#7e. Display the most frequently rented movies in descending order.

SELECT F.title,COUNT(R.rental_id) AS 'rental_count'
FROM film F
LEFT JOIN inventory I ON F.film_id=I.inventory_id
LEFT JOIN rental R ON I.inventory_id=R.inventory_id
GROUP BY F.title
ORDER BY COUNT(R.rental_id) DESC;


#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT ST.store_id,SUM(P.amount) as 'revenue'
FROM store S
INNER JOIN staff ST ON S.store_id=ST.store_id
INNER JOIN address A ON A.address_id=S.address_id
INNER JOIN payment P ON P.staff_id=ST.staff_id
GROUP BY ST.store_id;


#7g. Write a query to display for each store its store ID, city, and country.
SELECT ST.store_id,C.city,CTR.country
FROM store ST
INNER JOIN address A ON ST.address_id=A.address_id
INNER JOIN city C ON C.city_id=A.city_id
INNER JOIN country CTR ON C.country_id=CTR.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT  C.name, SUM(P.amount) AS 'gross_revenue'
FROM film_category FC
INNER JOIN category C ON FC.category_id=C.category_id
INNER JOIN inventory I ON I.film_id=FC.film_id
INNER JOIN rental R ON R.inventory_id=I.inventory_id
INNER JOIN payment P ON P.rental_id=R.rental_id
GROUP BY C.name
ORDER BY SUM(P.amount) DESC
LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view

CREATE VIEW view_top_five_genre AS
SELECT  C.name, SUM(P.amount) AS 'gross_revenue'
FROM film_category FC
INNER JOIN category C ON FC.category_id=C.category_id
INNER JOIN inventory I ON I.film_id=FC.film_id
INNER JOIN rental R ON R.inventory_id=I.inventory_id
INNER JOIN payment P ON P.rental_id=R.rental_id
GROUP BY C.name
ORDER BY SUM(P.amount) DESC
LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM view_top_five_genre;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW view_top_five_genre;







