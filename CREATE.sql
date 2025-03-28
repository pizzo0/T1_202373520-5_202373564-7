CREATE DATABASE gescon;
\c gescon;                                      --postgreSQL

CREATE DOMAIN "Rut" VARCHAR(10) NOT NULL;       --formato: 11111111-1
CREATE DOMAIN "Nombre" VARCHAR(255) NOT NULL;
CREATE DOMAIN "Email" VARCHAR(255) NOT NULL;

CREATE DOMAIN "Fecha" DATE NOT NULL;


CREATE TABLE Autores (
    rut "Rut" PRIMARY KEY,
    nombre "Nombre",
    email "Email"
);

CREATE TABLE Revisores (
    rut "Rut" PRIMARY KEY,
    nombre "Nombre",
    email "Email",
    especialidad VARCHAR(100) NOT NULL
);

CREATE TABLE Articulos (
    id_articulo SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    fecha_envio "Fecha",
    resumen VARCHAR(150) NOT NULL,
    topicos VARCHAR(255) NOT NULL
);