
use sakila;
-- 1a. Display the first and last names of all actors from the table 
select first_name, last_name from actor;

--1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
select concat(first_name, " ", last_name) as 'Actor Name' from actor limit 10;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?

select actor_id, first_name, last_name
from actor
where first_name like 'joe%'

-- 2b. Find all actors whose last name contain the letters GEN:
select first_name, last_name 
from actor
where last_name like '%Gen%'

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:

select first_name, last_name from actor
where last_name like '%li%'
order by last_name, first_name

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China

select country_id, country,last_update
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD description BLOB;

-- 3b
alter table actor
drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(last_name) 
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

select last_name, count(last_name) as 'Number of actor'
from actor
group by last_name 
having count(last_name) > 1;


-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.

update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d.

update actor
set first_name =  'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table.
--  Which query would you use to re-create it?

SHOW CREATE TABLE address;

-- 6a. 

select staff.first_name, staff.last_name, address.address, address.address2, 
address.district, address.postal_code
from staff inner join address on staff.address_id = address.address_id;

-- 6b.
select staff.first_name, staff.last_name, sum(payment_date)
from staff inner join payment on staff.staff_id = payment.payment_id
where year(payment.payment_date) = 2005 and month(payment.payment_date) = 8;

-- 6c
select film.title, sum(film_actor.actor_id) as 'Count of actor'
from film inner join film_actor
on film.film_id = film_actor.film_id
group by film.title;

-- 6d Hunchback Impossible
select count(*) as 'Copies'
from film inner join inventory 
on film.film_id = inventory.film_id
where film.title = 'Hunchback Impossible';

-- 6e

select customer.first_name, customer.last_name, sum(payment.amount) as 'Total Amount Paid'
from payment inner join customer
on payment.customer_id = customer.customer_id 
group by customer.first_name, customer.last_name
order by customer.last_name;

-- 7a

select title from film
where (title like 'K%' or title like 'Q%')
and language_id =
(select language_id from language 
where name = 'English')

-- 7b

select actor.first_name, actor.last_name
from actor 
where actor_id in
(select film_actor.actor_id 
from film_actor inner join film
on film_actor.film_id = film.film_id
where film.title = 'Alone Trip')
;

-- 7c

select customer.first_name, customer.last_name, customer.email
from customer 
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id 
inner join country on city.country_id = country.country_id
where country.country = 'Canada';

-- 7d


select film.title
from film 
inner join film_category on film_category.film_id = film.film_id
inner join category on film_category.category_id = category.category_id
where category.name = 'family';

-- 7e
select film.title, count(film.film_id)
from film 
inner join inventory on film.film_id = inventory.film_id
inner join rental on rental.inventory_id = inventory.inventory_id
group by film.title
order by count(film.film_id) desc;

-- 7f

select staff.store_id, sum(payment.amount) as 'Total Revenue'
from staff
inner join payment on staff.staff_id = payment.staff_id
group by staff.store_id;


-- 7g
select store.store_id, city.city, country.country
from store
inner join address on store.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id


-- 7h


select category.name, sum(payment.amount) as Gross_Revenue
from category
inner join film_category on category.category_id = film_category.category_id
inner join inventory on film_category.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join payment on rental.rental_id = payment.rental_id
group by category.name 
order by Gross_Revenue desc
limit 5;

-- 8a
Create view Top_5_Genres_By_Revenue as
(select category.name, sum(payment.amount) as Gross_Revenue
from category
inner join film_category on category.category_id = film_category.category_id
inner join inventory on film_category.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join payment on rental.rental_id = payment.rental_id
group by category.name 
order by Gross_Revenue desc
limit 5);

-- 8b
SHOW CREATE View Top_5_Genres_By_Revenue;

-- 8c
drop View Top_5_Genres_By_Revenue;

