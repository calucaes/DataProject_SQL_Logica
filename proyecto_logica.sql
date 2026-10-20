/** 1. Crea el esquema de la BBDD.
   adjunto esquema en archivo de imagen              **/


-- 2. Nombres de todas las películas con clasificación 'R'.
SELECT f.title
FROM film AS f
WHERE f.rating = 'R';


-- 3. Nombres de los actores con actor_id entre 30 y 40.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id BETWEEN 30 AND 40;


-- 4. Películas cuyo idioma coincide con el idioma original.
SELECT f.title, f.language_id, f.original_language_id
FROM film AS f
WHERE f.language_id = f.original_language_id;
-- no se si es un fallo de la base de datos, pero todas las original_language_id salen Nullr.


-- 5. Películas ordenadas por duración de forma ascendente.
SELECT f.title, f.length
FROM film AS f
ORDER BY f.length ASC;


-- 6. Nombre y apellido de los actores con 'Allen' en su apellido.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.last_name LIKE '%ALLEN%';


-- 7. Cantidad total de películas en cada clasificación.
SELECT f.rating, COUNT(*) AS total_peliculas
FROM film AS f
GROUP BY f.rating
ORDER BY total_peliculas DESC;


-- 8. Películas 'PG-13' o con duración mayor a 3 horas (180 minutos).
SELECT f.title, f.rating, f.length
FROM film AS f
WHERE f.rating = 'PG-13'
   OR f.length > 180;


-- 9. Variabilidad del coste de reemplazo de las películas.
SELECT ROUND(VARIANCE(f.replacement_cost), 2) AS varianza,
       ROUND(STDDEV(f.replacement_cost), 2)   AS desviacion_estandar
FROM film AS f;


-- 10. Mayor y menor duración de una película.
SELECT MAX(f.length) AS duracion_maxima,
       MIN(f.length) AS duracion_minima
FROM film AS f;


/** 11. Lo que costó el antepenúltimo alquiler ordenado por día.
  añado rental_id como segundo criterio para que el orden sea siempre el mismo,
  ya que hay mas de una fecha igual. **/
SELECT r.rental_id, r.rental_date, p.amount
FROM rental AS r
INNER JOIN payment AS p ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC, r.rental_id DESC
LIMIT 1 OFFSET 2;


-- 12. Películas que no sean ni 'NC-17' ni 'G'.
SELECT f.title, f.rating
FROM film AS f
WHERE f.rating NOT IN ('NC-17', 'G');


-- 13. Promedio de duración de las películas por clasificación.
SELECT f.rating, ROUND(AVG(f.length), 2) AS duracion_media
FROM film AS f
GROUP BY f.rating
ORDER BY duracion_media DESC;


-- 14. Películas con duración mayor a 180 minutos.
SELECT f.title, f.length
FROM film AS f
WHERE f.length > 180;


-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(p.amount) AS ingresos_totales
FROM payment AS p;


-- 16. Los 10 clientes con mayor valor de id.
SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
ORDER BY c.customer_id DESC
LIMIT 10;


-- 17. Actores que aparecen en la película 'Egg Igby'.
SELECT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film AS f        ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY';


-- 18. Todos los nombres de películas únicos.
SELECT DISTINCT f.title
FROM film AS f
ORDER BY f.title;


-- 19. Películas que son comedias y duran más de 180 minutos.
SELECT f.title, f.length
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c       ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;


-- 20. Categorías con promedio de duración superior a 110 minutos.
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_media
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f           ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY duracion_media DESC;


-- 21. Media de duración del alquiler de las películas.

SELECT ROUND(AVG(DATE(r.return_date) - DATE(r.rental_date)), 2) AS duracion_media_real_dias
FROM rental AS r;

--     b) Duración de alquiler fijada para cada película en diass
SELECT ROUND(AVG(f.rental_duration), 2) AS duracion_media_dias
FROM film AS f;


-- 22. Columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
FROM actor AS a;


-- 23. Número de alquileres por día, ordenados de mayor a menor.
SELECT DATE(r.rental_date) AS dia, COUNT(*) AS total_alquileres
FROM rental AS r
GROUP BY DATE(r.rental_date)
ORDER BY total_alquileres DESC;


-- 24. Películas con una duración superior al promedio.
SELECT f.title, f.length
FROM film AS f
WHERE f.length > (SELECT AVG(length) FROM film)
ORDER BY f.length DESC;


-- 25. Número de alquileres registrados por mes.
SELECT EXTRACT(YEAR FROM r.rental_date)  AS anio,
       EXTRACT(MONTH FROM r.rental_date) AS mes,
       COUNT(*) AS total_alquileres
FROM rental AS r
GROUP BY anio, mes
ORDER BY anio, mes;


-- 26. Promedio, desviación estándar y varianza del total pagado.
SELECT ROUND(AVG(p.amount), 2)      AS promedio,
       ROUND(STDDEV(p.amount), 2)   AS desviacion_estandar,
       ROUND(VARIANCE(p.amount), 2) AS varianza
FROM payment AS p;


-- 27. Películas que se alquilan por encima del precio medio.
SELECT f.title, f.rental_rate
FROM film AS f
WHERE f.rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY f.title;


-- 28. Id de los actores que han participado en más de 40 películas.
SELECT fa.actor_id, COUNT(fa.film_id) AS num_peliculas
FROM film_actor AS fa
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) > 40;


/** 29. Todas las películas y, si están en el inventario, la cantidad disponible.
le meto un LEFT JOIN para que salgan también las que no tienen copias (cantidad 0). **/
SELECT f.title, COUNT(i.inventory_id) AS cantidad_inventario
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;


-- 30. Actores y número de películas en las que han actuado.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;


-- 31. Todas las películas y sus actores, incluso las que no tienen actores.
SELECT f.title, a.first_name, a.last_name
FROM film AS f
LEFT JOIN film_actor AS fa ON f.film_id = fa.film_id
LEFT JOIN actor AS a       ON fa.actor_id = a.actor_id
ORDER BY f.title;


-- 32. Todos los actores y sus películas, incluso los que no tienen películas.
SELECT a.first_name, a.last_name, f.title
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
LEFT JOIN film AS f        ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name;


/** 33. Todas las películas y todos los registros de alquiler.
le meto un FULL JOIN para  no perder películas sin alquileres ni alquileres sin película. **/
SELECT f.title, r.rental_id, r.rental_date
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id = i.film_id
FULL JOIN rental AS r    ON i.inventory_id = r.inventory_id
ORDER BY f.title;


-- 34. Los 5 clientes que más dinero se han gastado.
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_gastado
FROM customer AS c
INNER JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;


-- 35. Actores cuyo primer nombre es 'Johnny'.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name = 'JOHNNY';


-- 36. Renombrar first_name como Nombre y last_name como Apellido.
SELECT a.first_name AS "Nombre",
       a.last_name  AS "Apellido"
FROM actor AS a;


-- 37. ID del actor más bajo y más alto.
SELECT MIN(a.actor_id) AS id_minimo,
       MAX(a.actor_id) AS id_maximo
FROM actor AS a;


-- 38. Cuántos actores hay en la tabla actor.
SELECT COUNT(*) AS total_actores
FROM actor AS a;


-- 39. Todos los actores ordenados por apellido ascendente.
SELECT a.first_name, a.last_name
FROM actor AS a
ORDER BY a.last_name ASC;


-- 40. Las primeras 5 películas de la tabla film.
SELECT f.film_id, f.title
FROM film AS f
ORDER BY f.film_id
LIMIT 5;


-- 41. Actores agrupados por nombre: cuántos comparten nombre.
SELECT a.first_name, COUNT(*) AS total
FROM actor AS a
GROUP BY a.first_name
ORDER BY total DESC;
-- El nombre más repetido: KENNETH, PENELOPE y JULIA,



-- 42. Todos los alquileres y el nombre del cliente que los realizó.
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental AS r
INNER JOIN customer AS c ON r.customer_id = c.customer_id
ORDER BY r.rental_date;


-- 43. Todos los clientes y sus alquileres, incluidos los que no tienen.
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
ORDER BY c.customer_id;


-- 44. CROSS JOIN entre film y category.
SELECT f.title, c.name AS categoria
FROM film AS f
CROSS JOIN category AS c;
/** ¿Aporta valor? No. El CROSS JOIN combina cada película con todas  las
   categorías que son 16000 filas, aunque
   cada película pertenece solo a una. El resultado no refleja la
   realidad y puede llevar a conclusiones erroneas. Para saber la
   categoría real hay que unir las tablas a través de film_category.   **/


-- 45. Actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa    ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
INNER JOIN category AS c       ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name;


-- 46. Actores que no han participado en ninguna película.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (SELECT fa.actor_id FROM film_actor AS fa);
-- sin resultados, supongo que es porque todos los actores tiene como minimo una peli.


-- 47. Nombre de los actores y cantidad de películas en las que han participado.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;


-- 48. Vista "actor_num_peliculas": nombre de los actores y nº de películas.
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Comprobación de la vista
SELECT * FROM actor_num_peliculas ORDER BY num_peliculas DESC;


-- 49. Número total de alquileres realizados por cada cliente.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;


-- 50. Duración total de las películas de la categoría 'Action'.
SELECT SUM(f.length) AS duracion_total_minutos
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c       ON fc.category_id = c.category_id
WHERE c.name = 'Action';


-- 51. Tabla temporal "cliente_rentas_temporal": total de alquileres por cliente.

CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Comprobación
SELECT * FROM cliente_rentas_temporal ORDER BY total_alquileres DESC;


-- 52. Tabla temporal "peliculas_alquiladas": películas alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS veces_alquilada
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Comprobación
SELECT * FROM peliculas_alquiladas ORDER BY veces_alquilada DESC;


-- 53. Películas alquiladas por 'Tammy Sanders' que aún no se han devuelto, ord alfabeticamente.

SELECT f.title
FROM customer AS c
INNER JOIN rental AS r    ON c.customer_id = r.customer_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f      ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY'
  AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title;


-- 54. Actores que han actuado en al menos una película 'Sci-Fi', ord por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa    ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
INNER JOIN category AS c       ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;


/** 55. Actores que han actuado en películas alquiladas después de que
   'Spartacus Cheaper' se alquilara por primera vez. Orden por apellido.
    Se usa un CTE para calcular primero la fecha del primer alquiler. **/
WITH primer_alquiler_spartacus AS (
    SELECT MIN(r.rental_date) AS fecha
    FROM rental AS r
    INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
    INNER JOIN film AS f      ON i.film_id = f.film_id
    WHERE f.title = 'SPARTACUS CHEAPER')
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN inventory AS i   ON fa.film_id = i.film_id
INNER JOIN rental AS r      ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (SELECT fecha FROM primer_alquiler_spartacus)
ORDER BY a.last_name;


-- 56. Actores que no han actuado en ninguna película de la categoría 'Music'.

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
    INNER JOIN category AS c       ON fc.category_id = c.category_id
    WHERE c.name = 'Music')
ORDER BY a.last_name;


-- 57. Películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT f.title
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r    ON i.inventory_id = r.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;


-- 58. Películas que son de la misma categoría que 'Animation'.
SELECT f.title
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
    SELECT c.category_id
    FROM category AS c
    WHERE c.name = 'Animation')
ORDER BY f.title;


-- 59. Películas con la misma duración que 'Dancing Fever', ord alfabético.
SELECT f.title, f.length
FROM film AS f
WHERE f.length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER')
ORDER BY f.title;


-- 60. Clientes que han alquilado al menos 7 películas distintas, ord apellido.
SELECT c.first_name, c.last_name, COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer AS c
INNER JOIN rental AS r    ON c.customer_id = r.customer_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name;


-- 61. Total de películas alquiladas por categoría.
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN inventory AS i      ON fc.film_id = i.film_id
INNER JOIN rental AS r         ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;


-- 62. Número de películas por categoría estrenadas en 2006.
SELECT c.name AS categoria, COUNT(f.film_id) AS num_peliculas
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f           ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY num_peliculas DESC;


-- 63. Todas las combinaciones posibles de trabajadores con las tiendas.
SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff AS s
CROSS JOIN store AS st
ORDER BY s.staff_id, st.store_id;


-- 64. Total de películas alquiladas por cada cliente: id, nombre, apellido y cantidad.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS peliculas_alquiladas
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY peliculas_alquiladas DESC;