CREATE DATABASE gescon;
\c gescon;                                  --postgreSQL

CREATE TABLE Autores (
    rut VARCHAR(10) PRIMARY KEY,            --formato: 11111111-1
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Revisores (
    rut VARCHAR(10) PRIMARY KEY,            --formato: 11111111-1
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    especialidad VARCHAR(100) NOT NULL
)

CREATE TABLE Articulos (
    id_articulo SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    fecha_envio DATE NOT NULL,
    resumen VARCHAR(150) NOT NULL,
    topicos VARCHAR(255) NOT NULL
)