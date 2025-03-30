-- postgreSQL
-- CREATE DATABASE gescon;
-- \c gescon;

CREATE TABLE Autores (
    rut VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Revisores (
    rut VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Topicos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Articulos (
    id_articulo SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    fecha_envio DATE NOT NULL,
    resumen TEXT NOT NULL
);

CREATE TABLE Revisores_Especialidades (
    rut_revisor VARCHAR(10) NOT NULL,
    id_topico INT NOT NULL,
    PRIMARY KEY (rut_revisor, id_topico),
    FOREIGN KEY (rut_revisor) REFERENCES Revisores(rut) ON DELETE CASCADE,
    FOREIGN KEY (id_topico) REFERENCES Topicos(id) ON DELETE CASCADE
);

CREATE TABLE Articulos_Topicos (
    id_articulo INT NOT NULL,
    id_topico INT NOT NULL,
    PRIMARY KEY (id_articulo, id_topico),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id_articulo) ON DELETE CASCADE,
    FOREIGN KEY (id_topico) REFERENCES Topicos(id) ON DELETE CASCADE
);

CREATE TABLE Articulos_Autores (
    id_articulo INT NOT NULL,
    rut_autor VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_articulo, rut_autor),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id_articulo) ON DELETE CASCADE,
    FOREIGN KEY (rut_autor) REFERENCES Autores(rut) ON DELETE CASCADE
);

CREATE TABLE Articulos_Revisores (
    id_articulo INT NOT NULL,
    rut_revisor VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_articulo, rut_revisor),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id_articulo) ON DELETE CASCADE,
    FOREIGN KEY (rut_revisor) REFERENCES Revisores(rut) ON DELETE CASCADE
);