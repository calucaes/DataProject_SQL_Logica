DataProject: Lógica de Consultas SQL
1. Descripción del proyecto

El objetivo es resolver 64 ejercicios de consultas SQL sobre la base de datos Shakila, que simula un videoclub: películas, actores, categorías, inventario, alquileres, pagos, clientes, empleados y tiendas.

Con el proyecto se demuestran estos conocimientos:

Manejo de la herramienta DBeaver.
Consultas sobre una sola tabla (SELECT, WHERE, ORDER BY, LIMIT, funciones de agregación).
Relaciones entre tablas (INNER JOIN, LEFT JOIN, FULL JOIN, CROSS JOIN).
Subconsultas y CTEs (WITH).
Vistas (CREATE VIEW).
Estructuras de datos temporales (CREATE TEMPORARY TABLE).
Buenas prácticas.

Herramientas: PostgreSQL y DBeaver.

2. Estructura del proyecto

proyecto_logica.sql Es el archivo principal del proyecto. Contiene las 64 consultas, numeradas en el mismo orden que el enunciado. Cada una lleva un comentario que explica qué hace y, cuando hace falta, por qué se ha resuelto de esa manera o por qué el resultado sale vacío.

Esquema_BBDD.png Es la imagen del diagrama entidad-relación de la base de datos, exportada desde DBeaver. Responde al ejercicio 1 y muestra las 15 tablas, sus claves y cómo se relacionan entre ellas.

README.md Es este documento. Explica el objetivo del proyecto, cómo cargar la base de datos, cómo está organizada, qué buenas prácticas se han seguido y los resultados más destacados.

3. Carga de la base de datos
Crear una base de datos nueva en PostgreSQL desde DBeaver (por ejemplo, shakila).
Abrir el archivo BBDD_Proyecto_shakila_sinuser.sql y ejecutarlo como script (Alt + X).
Refrescar el esquema public para ver las 15 tablas.
Abrir proyecto_logica.sql y ejecutar cada consulta con Ctrl + Enter.
4. Esquema de la base de datos

Se ha creado un esquema de la base de datos.

5. Buenas prácticas aplicadas
Palabras reservadas en mayúsculas y una cláusula por línea.
Alias cortos y claros en las tablas (f = film, a = actor, r = rental...).
JOIN explícitos con ON, en lugar de unir las tablas en el WHERE.
Alias descriptivos en español para las columnas calculadas (total_alquileres, duracion_media...).
Comentarios en cada ejercicio, y también en los casos en los que el resultado puede sorprender.
En el GROUP BY se incluye el id junto al nombre para no juntar dos personas que se llamen igual.
Los textos de la base de datos están en MAYÚSCULAS, por lo que los filtros se escriben igual ('EGG IGBY', 'TAMMY').
6. Resultados destacados
La empresa ha ingresado 67.416,51 en total (ejercicio 15).
Ninguna película tiene informado el idioma original, así que el ejercicio 4 devuelve 0 filas.
Todos los actores tienen al menos una película, así que el ejercicio 46 devuelve 0 filas.
Solo 2 actores han participado en más de 40 películas (ejercicio 28).
Los nombres de actor más repetidos son JULIA, KENNETH y PENELOPE, con 4 actores cada uno (ejercicio 41).
La duración media real de un alquiler es de unos 5 días (ejercicio 21).
Hay 42 películas sin ninguna copia en el inventario. Con el LEFT JOIN del ejercicio 29 aparecen igualmente, con cantidad 0.
El CROSS JOIN entre film y category (ejercicio 44) genera 16.000 filas sin sentido real. La explicación está en el script.
7. Autoría

Carlos Luque Camacho