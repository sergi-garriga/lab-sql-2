use sakila;

-- Select all the actors with the first name ‘Scarlett’.
select *
from actor
where first_name = "Scarlett";
			-- Scarlett Damon, Scarlett Bening


-- Select all the actors with the last name ‘Johansson’.
select *
from actor
where last_name = "Johansson";
			-- Matthew Johansson, Ray Johansson, Albert Johansson


-- How many films (movies) are available for rent?
select count(*)
from inventory;
			-- 4581


-- How many films have been rented?
select count(*)
from rental;
			-- there have been 16044 rentals
select count(distinct inventory_id)
from rental;
			-- there have been 4580 unique rentals. One film, has never been rented.
select title 
from film
where film_id = (select film_id from inventory where inventory_id NOT IN (SELECT inventory_id FROM rental));
			-- this film was, sadly, Academy Dinosaur.


-- What is the shortest and longest rental period?
select max(timediff(return_date, rental_date)) as max_rental_period 
from rental;
			-- 221:59:00
select min(timediff(return_date, rental_date)) as min_rental_period 
from rental;
			-- 18:00:00


-- What are the shortest and longest movie duration? Name the values max_duration and min_duration.
select max(length) as max_duration
from film;
			-- 185 minutes
select min(length) as min_duration
from film;
			-- 46 minutes
select film_id, title, length
from film
where (length = (select max(length) from film)) OR (length = (select min(length) from film))
order by length asc;
			-- titles...


-- What's the average movie duration?
select round(avg(length), 2) as average_movie_duration
from film;
			-- 115,27 minutes


-- What's the average movie duration expressed in format (hours, minutes)?
select convert(avg(length), '00:00')
from film; -- not working
select convert(time, avg(length),8)
from film; -- not working
select convert(avg(length), time) as average_movie_duration
from film;
		-- I cannot get that one. This is giving 00:01:15, which cannot be correct because 1 minute and 15 seconds is a
		-- misunderstanding of the 115,27 average value. Probably, the machine understands the value as seconds.
select convert(avg(length)*60, time) as average_movie_duration
from film;
		-- But if I try to convert the minutes to seconds, it is returning a null value. I don't know why, because it is 
		-- working properly without the convert function.
select round(avg(length)*60, 2) as average_movie_duration
from film;


-- How many movies longer than 3 hours?
select count(*)
from film
where length > 180;
			-- 39 movies


-- Get the name and email formatted. Example: Mary SMITH - mary.smith@sakilacustomer.org.
select concat(upper(left(first_name,1)), lower(substring(first_name,2,length(first_name)))),  upper(last_name), lower(email)
from customer;
			-- there it goes...


-- What's the length of the longest film title?
select max(length(title))
from film;
			-- 27 characters
