-- PostgreSQL
-- CREATE DATABASE gescon;
-- \c gescon;

CREATE TABLE Usuarios (
    rut VARCHAR(12) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Topicos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Articulos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    fecha_envio DATE NOT NULL DEFAULT CURRENT_DATE,
    resumen VARCHAR(150) NOT NULL,
    rut_contacto VARCHAR(12) NOT NULL,
    FOREIGN KEY (rut_contacto) REFERENCES Usuarios(rut) ON DELETE CASCADE
);

CREATE TABLE Usuarios_Especialidades (
    rut_usuario VARCHAR(12) NOT NULL,
    id_topico INT NOT NULL,
    PRIMARY KEY (rut_usuario, id_topico),
    FOREIGN KEY (rut_usuario) REFERENCES Usuarios(rut) ON DELETE CASCADE,
    FOREIGN KEY (id_topico) REFERENCES Topicos(id) ON DELETE CASCADE
);

CREATE TABLE Articulos_Topicos (
    id_articulo INT NOT NULL,
    id_topico INT NOT NULL,
    PRIMARY KEY (id_articulo, id_topico),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_topico) REFERENCES Topicos(id) ON DELETE CASCADE
);

CREATE TABLE Articulos_Autores (
    id_articulo INT NOT NULL,
    rut_autor VARCHAR(12) NOT NULL,
    PRIMARY KEY (id_articulo, rut_autor),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id) ON DELETE CASCADE,
    FOREIGN KEY (rut_autor) REFERENCES Usuarios(rut) ON DELETE CASCADE
);

CREATE TABLE Articulos_Revisores (
    id_articulo INT NOT NULL,
    rut_revisor VARCHAR(12) NOT NULL,
    PRIMARY KEY (id_articulo, rut_revisor),
    FOREIGN KEY (id_articulo) REFERENCES Articulos(id) ON DELETE CASCADE,
    FOREIGN KEY (rut_revisor) REFERENCES Usuarios(rut) ON DELETE CASCADE,
    CONSTRAINT autor_no_revisor CHECK (
        rut_revisor NOT IN (
            SELECT rut_autor
            FROM Articulos_Autores
            WHERE Articulos_Autores.id_articulo = Articulos_Revisores.id_articulo
        )
    )
);