-- Taller 2 - SQL Practico (Sakila)
-- Juan Pablo Arevalo Socha 
-- =================================================================
-- Conexion a la Base de datos
USE sakila;
-- =================================================================
-- SELECT y WHERE
-- =================================================================

-- 1 Mostrar nombre y apellido de todos los clientes
SELECT first_name, last_name FROM customer;

-- 2 Peliculas con duracion mayor a 120 minutos
SELECT title, length FROM film
WHERE length > 120;

-- Se utiliza un SELECT para consultar de la BD el primer nombre y apellido desde la tabla customer
-- Se utiliza el WHERE para filtrar una caracteristica, en este caso duracion de film mayor a 120 
-- =================================================================
-- ORDER BY
-- =================================================================

-- 3 Ordenar clientes por apellido --> Por orden alfabetico de la A a la Z
SELECT first_name, last_name FROM customer
ORDER BY last_name ASC;

-- 4 Top 5 películas más largas --> TIP: Use la palabra LIMIT
SELECT title, length FROM film
ORDER BY length DESC
LIMIT 5;

-- Se ordenan los clientes por medio del campo last_name en orden ascendente mediante uso de ORDER BY y ASC
-- Se ordenan las peliculas de mayor a menor y se muestran unicamente 5 registros con LIMIT
-- =================================================================
-- INNER JOIN
-- =================================================================

-- 5 Cantidad pagada y fecha del pago con nombre y apellido del cliente (JOIN entre Payment - Customer)
SELECT customer.first_name,customer.last_name,payment.amount,payment.payment_date 
FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id;

-- 6 Películas alquiladas (JOIN entre Rental - Inventory - Film)
SELECT film.title,rental.rental_date FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id;

-- Se realiza un join entre payment y customer relacionados por el customer_id
-- Se realiza un join entre rental, inventory y film relacionados por  inventory_id y por film_id, se muestra como resultado: de la tabla film el title y de la tabla rental la rental_date
-- =================================================================
-- LEFT JOIN
-- =================================================================

-- 7 Nombre y apellido de clientes sin pagos (LEFT JOIN entre Payment - Customer pero usando WHERE)
SELECT customer.first_name, customer.last_name FROM customer
LEFT JOIN payment ON payment.customer_id = customer.customer_id
WHERE payment.payment_id IS NULL;

-- 8 Listar los nombres de las peliculas y su duracion de aquellos titulos que no tienen actores
SELECT film.title,film.length FROM film
LEFT JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IS NULL;

-- Se realiza un join  entre customer y payment por medio de customer_id y se filtra donde el payment_id sea nulo
-- Se realiza un join  entre film y film_actor por medio del film_id y se filtra donde el actor_id sea nulo
-- =================================================================
-- INSERT, UPDATE, DELETE (Data Definition Language)
-- =================================================================

-- 9 Insertar actor temporal
INSERT INTO actor (first_name,last_name)
VALUES ("CRISTIANO","RONALDO");
SELECT * FROM actor;

-- 10 Actualizar actor
UPDATE actor
SET first_name = "KYLIAN", last_name = "MBAPPE"
WHERE actor_id = 209;
SELECT * FROM actor;

-- 11 Eliminar actor
DELETE FROM actor
WHERE actor_id = 209;
SELECT * FROM actor;

-- Por medio de INSERT INTO agregamos un actor a la tabla actor, con el SELECT revisamos que se incluyo al final
-- Por medio de UPDATE, actualizamos la informacion del actor ingresado, teniendo en cuenta el actor_id que es consecutivo
-- Por medio de DELETE FROM, eliminamos el actor ingresado, teniendo como referencia el actor_id que es consecutivo

-- =================================================================
-- Consultas Avanzadas
-- =================================================================

-- 12 Top 5 clientes con mayor cantidad de dinero pagado al servicio de rentas
SELECT customer.first_name,customer.last_name, SUM(payment.amount) AS total_pagado
FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id,customer.first_name,customer.last_name
ORDER BY total_pagado DESC LIMIT 5;

-- 13 Top 5 Películas más alquiladas (JOIN entre Rental - Inventory - Film) --> Agrupar los datos con conteo y tomar las mejores 5
SELECT film.title, COUNT(rental.rental_id) AS cantidad
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY film.film_id, film.title
ORDER BY cantidad DESC LIMIT 5;

-- Hacemos un join entre payment y customer por medio del customer_id, por medio de SUM se realiza suma del total pagado y se agrupan para mostrar los 5 clientes con mas gasto
-- Hacemos un join entre rental, inventory y film por medio de inventory_id y de film_id, se realiza un conteo de rental_id  y se agrupan para mostrar las 5 peliculas mas alquiladas