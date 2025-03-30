-- Consultas requeridas
-- Obtener los nombres y resúmenes de todos los artículos que comiencen con la letra 'O'
SELECT titulo, resumen FROM Articulos WHERE titulo LIKE 'O%';

-- Obtener la cantidad de artículos enviados por cada autor
SELECT Autores.nombre, COUNT(Articulos_Autores.id_articulo) AS cantidad_articulos FROM Autores
JOIN Articulos_Autores ON Autores.rut = Articulos_Autores.rut_autor GROUP BY Autores.nombre;

-- Obtener los títulos de los artículos que tienen más de un tópico asignado
SELECT Articulos.titulo FROM Articulos JOIN Articulos_Topicos ON Articulos.id = Articulos_Topicos.id_articulo
GROUP BY Articulos.id, Articulos.titulo HAVING COUNT(Articulos_Topicos.id_topico) > 1;

-- Mostrar título del artículo y datos del autor para artículos con 'Software' en el título
SELECT Articulos.titulo, Autores.* FROM Articulos
JOIN Articulos_Autores ON Articulos.id = Articulos_Autores.id_articulo
JOIN Autores ON Articulos_Autores.rut_autor = Autores.rut WHERE Articulos.titulo ILIKE '%Software%';

-- Obtener el nombre y cantidad de artículos asignados a cada revisor
SELECT Revisores.nombre, COUNT(Articulos_Revisores.id_articulo) AS cantidad_articulos FROM Revisores
JOIN Articulos_Revisores ON Revisores.rut = Articulos_Revisores.rut_revisor GROUP BY Revisores.nombre;

-- Obtener los nombres de los revisores con más de 3 artículos asignados
SELECT Revisores.nombre FROM Revisores JOIN Articulos_Revisores ON Revisores.rut = Articulos_Revisores.rut_revisor
GROUP BY Revisores.nombre HAVING COUNT(Articulos_Revisores.id_articulo) > 3;

-- Obtener los títulos de los artículos y revisores asignados si contienen 'Gestión'
SELECT Articulos.titulo, Revisores.nombre FROM Articulos
JOIN Articulos_Revisores ON Articulos.id = Articulos_Revisores.id_articulo
JOIN Revisores ON Articulos_Revisores.rut_revisor = Revisores.rut WHERE Articulos.titulo ILIKE '%Gestión%';

-- Obtener la cantidad de revisores especialistas en cada tópico
SELECT Topicos.nombre AS topico, COUNT(Revisores_Especialidades.rut_revisor) AS cantidad_revisores FROM Topicos
JOIN Revisores_Especialidades ON Topicos.id = Revisores_Especialidades.id_topico
GROUP BY Topicos.nombre;

-- Obtener los 10 artículos más antiguos ingresados en la BD
SELECT titulo, fecha_envio FROM Articulos ORDER BY fecha_envio ASC LIMIT 10;

-- Obtener los nombres de los artículos cuyos revisores participan en 3 o más artículos
SELECT DISTINCT Articulos.titulo FROM Articulos JOIN Articulos_Revisores ON Articulos.id = Articulos_Revisores.id_articulo
WHERE Articulos_Revisores.rut_revisor IN (SELECT rut_revisor FROM Articulos_Revisores
GROUP BY rut_revisor HAVING COUNT(id_articulo) >= 3);