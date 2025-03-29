CREATE DATABASE gescon;
\c gescon;                                          --postgreSQL

CREATE DOMAIN "Rut" VARCHAR(10) NOT NULL;           --formato: 11111111-1
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
    email "Email"
);
CREATE TABLE Especialidades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Revisores_Especialidades (
    rut_revisor VARCHAR(10),
    id_especialidad INT,
    
    PRIMARY KEY (rut_revisor, id_especialidad),
    FOREIGN KEY (rut_revisor) REFERENCES Revisores(rut) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidad) REFERENCES Especialidades(id) ON DELETE CASCADE
);

CREATE TABLE Articulos (
    id_articulo SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    fecha_envio "Fecha",
    resumen VARCHAR(150) NOT NULL
);
CREATE TABLE Articulos_Autores (
    id_articulo INT,
    rut_autor VARCHAR(10),
    PRIMARY KEY (id_articulo, rut_autor),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id) ON DELETE CASCADE,
    FOREIGN KEY (rut_autor) REFERENCES Autores(rut) ON DELETE CASCADE
);
CREATE TABLE Articulos_Revisores (
    id_articulo INT,
    rut_revisores VARCHAR(10),
    PRIMARY KEY (id_articulo, rut_revisores),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id) ON DELETE CASCADE,
    FOREIGN KEY (rut_revisores) REFERENCES Revisores(rut) ON DELETE CASCADE
);

CREATE TABLE Topicos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Articulos_Topicos (
    id_articulo INT,
    id_topicos INT,
    PRIMARY KEY (id_articulo, id_topicos),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_topicos) REFERENCES Topicos(id) ON DELETE CASCADE
);
