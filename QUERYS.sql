-- CONSULTAS:
-- 1. Nombres y resúmenes de todos los artículos que comiencen con la letra O
SELECT titulo, resumen
FROM Articulos
WHERE titulo LIKE 'O%';

-- 2. Cantidad de artículos enviados por cada autor
SELECT Usuarios.nombre, COUNT(Articulos_Autores.id_articulo) AS cantidad_articulos
FROM Articulos_Autores
JOIN Usuarios ON Articulos_Autores.rut_autor = Usuarios.rut
GROUP BY Usuarios.nombre;

-- 3. Títulos de los artículos que tienen más de un tópico asignado
SELECT Articulos.titulo
FROM Articulos
JOIN Articulos_Topicos ON Articulos.id = Articulos_Topicos.id_articulo
GROUP BY Articulos.id, Articulos.titulo
HAVING COUNT(Articulos_Topicos.id_topico) > 1;

-- 4. Título del artículo y toda la información del autor de contacto donde el título contiene "Software"
SELECT Articulos.titulo, Usuarios.*
FROM Articulos
JOIN Usuarios ON Articulos.rut_contacto = Usuarios.rut
WHERE Articulos.titulo ILIKE '%Software%';

-- 5. Nombre y cantidad de artículos asignados a cada revisor
SELECT Usuarios.nombre, COUNT(Articulos_Revisores.id_articulo) AS cantidad_articulos
FROM Articulos_Revisores
JOIN Usuarios ON Articulos_Revisores.rut_revisor = Usuarios.rut
GROUP BY Usuarios.nombre;

-- 6. Nombres de los revisores que tienen asignados más de 3 artículos
SELECT Usuarios.nombre
FROM Articulos_Revisores
JOIN Usuarios ON Articulos_Revisores.rut_revisor = Usuarios.rut
GROUP BY Usuarios.nombre
HAVING COUNT(Articulos_Revisores.id_articulo) > 3;

-- 7. Títulos de los artículos y nombre de revisores asignados, solo si el título contiene "Gestión"
SELECT Articulos.titulo, Usuarios.nombre AS revisor
FROM Articulos
JOIN Articulos_Revisores ON Articulos.id = Articulos_Revisores.id_articulo
JOIN Usuarios ON Articulos_Revisores.rut_revisor = Usuarios.rut
WHERE Articulos.titulo ILIKE '%Gestion%';

-- 8. Cantidad de revisores que son especialistas en cada tópico
SELECT Topicos.nombre AS topico, COUNT(DISTINCT Usuarios_Especialidades.rut_usuario) AS cantidad_revisores
FROM Usuarios_Especialidades
JOIN Topicos ON Usuarios_Especialidades.id_topico = Topicos.id
JOIN Articulos_Revisores ON Articulos_Revisores.rut_revisor = Usuarios_Especialidades.rut_usuario
GROUP BY Topicos.nombre;

-- 9. Top 10 artículos más antiguos
SELECT titulo, fecha_envio
FROM Articulos
ORDER BY fecha_envio ASC
LIMIT 10;

-- 10. Nombres de los artículos cuyos revisores participan cada uno en 3 o más artículos
SELECT DISTINCT Articulos.titulo
FROM Articulos
JOIN Articulos_Revisores ON Articulos.id = Articulos_Revisores.id_articulo
WHERE Articulos_Revisores.rut_revisor IN (
    SELECT rut_revisor
    FROM Articulos_Revisores
    GROUP BY rut_revisor
    HAVING COUNT(*) >= 3
);